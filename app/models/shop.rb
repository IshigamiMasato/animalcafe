class Shop < ApplicationRecord
  belongs_to :user
  has_many :bookmarks, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :tag_maps, dependent: :destroy
  has_many :tags, through: :tag_maps

  default_scope -> { order(created_at: :desc) }

  # 検索メソッド
  scope :search, -> (search_params) do
    return if search_params[:address].blank?
    address_like(search_params[:address])
  end

  scope :address_like, -> (address) { where("address LIKE ?", "%#{address}%") }

  # geocode
  geocoded_by :address
  after_validation :geocode, if: :address_changed?

  validates :user_id, presence: true
  validates :name, presence: true,
                   length: { maximum: 50 },
                   uniqueness: true
  validates :started_at, presence: true
  validates :closed_at, presence: true
  validates :regular_holiday, presence: true
  validates :address, presence: true,
                      uniqueness: true
  validates :nearest_station, presence: true,
                              length: { maximum: 30 }
  validates :low_budget, presence: true
  validates :description, presence: true,
                          length: { maximum: 300 }

  # active_storage
  has_many_attached :images
  validates :images,
            content_type: {
              in: %w(image/jpeg image/gif image/png),
              message: "のフォーマットが無効です",
            },
            size: {
              less_than: 5.megabytes,
              message: "は5MB未満のファイルを選択してください",
            },
            limit: {
              max: 4,
              message: "は最大4枚までです",
            }

  # 店舗レビューの平均点
  def avg_score
    if reviews.empty?
      0.0
    else
      reviews.average(:score).round(1).to_f
    end
  end

  # 店舗レビューの平均の割合
  def avg_score_percentage
    if reviews.empty?
      0.0
    else
      reviews.average(:score).round(1).to_f / 5 * 100
    end
  end

  # 動物のタグを保存する
  def save_animal_tag(post_tags)
    current_tags = tags.where(tag_type: "animal").pluck(:name) unless tags.nil?
    old_tags = current_tags - post_tags
    new_tags = post_tags - current_tags

    old_tags.each do |old_tag|
      tags.delete(Tag.find_by(name: old_tag))
    end

    new_tags.each do |new_tag|
      post_tag = Tag.find_or_create_by(name: new_tag)
      post_tag.tag_type = "animal"

      tags << post_tag
    end
  end

  # 設備のタグを保存する
  def save_env_tag(post_tags)
    current_tags = tags.where(tag_type: "env").pluck(:name) unless tags.nil?
    old_tags = current_tags - post_tags
    new_tags = post_tags - current_tags

    old_tags.each do |old_tag|
      tags.delete(Tag.find_by(name: old_tag))
    end

    new_tags.each do |new_tag|
      post_tag = Tag.find_or_create_by(name: new_tag)
      post_tag.tag_type = "env"

      tags << post_tag
    end
  end
end
