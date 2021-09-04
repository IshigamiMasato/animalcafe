class Shop < ApplicationRecord
  belongs_to :user
  has_many :bookmarks, dependent: :destroy
  has_many :reviews, dependent: :destroy

  default_scope -> { order(created_at: :desc) }

  # 検索メソッド
  scope :search, -> (search_params) do
    return [] if search_params[:address].blank?
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
end
