class User < ApplicationRecord
  attr_accessor :remember_token

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
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  # 渡された文字列のハッシュ値を返す has_secure_passwordで使われている
  def User.digest(string)
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンを返す
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # 永続セッションのために、ユーザーのdbにハッシュ化した記憶トークンをいれる
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(remember_token) # has_serure_passwordのauthenticateメソッドとほぼ同じ
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end
end
