class User < ApplicationRecord
  # コールバック
  before_validation { email.downcase! }

  # active_storage関連
  has_one_attached :avater
  validates :avater,
            content_type: { # 画像フォーマットのバリデーション
              in: %w(image/jpeg image/gif image/png),
              message: "のフォーマットが無効です",
            },
            size: { # 画像サイズのバリデーション
              less_than: 5.megabytes,
              message: "は5MB未満のファイルを選択してください",
            }

  # バリデーション
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true

  # has_secure_password関連
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }
end
