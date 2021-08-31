class Shop < ApplicationRecord
  belongs_to :user
  has_many :bookmarks, dependent: :destroy

  # shopの並び順
  default_scope -> { order(created_at: :desc) }

  # 検索メソッド
  scope :search, -> (search_params) do
    return [] if search_params[:address].blank?
    address_like(search_params[:address])
  end

  scope :address_like, -> (address) { where("address LIKE ?", "%#{address}%") }

  # geocode関連
  geocoded_by :address
  after_validation :geocode, if: :address_changed?

  # バリデーション
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

  # active_storage関連
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
end
