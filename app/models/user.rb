class User < ApplicationRecord
  has_many :shops, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :bookmarking, through: :bookmarks, source: :shop
  has_many :reviews, dependent: :destroy

  attr_accessor :remember_token, :activation_token, :reset_token

  # コールバック
  before_validation :downcase_email
  before_create :create_activation_digest

  # active_storage
  has_one_attached :avater
  validates :avater,
            content_type: {
              in: %w(image/jpeg image/gif image/png),
              message: "のフォーマットが無効です",
            },
            size: {
              less_than: 5.megabytes,
              message: "は5MB未満のファイルを選択してください",
            }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true

  # has_secure_password
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  # 渡された文字列のハッシュ値を返す has_secure_passwordで使用
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

  # 渡されたトークンがダイジェストと一致したらtrueを返す、rememberとactivationで使用
  def authenticated?(attribute, token) # has_serure_passwordのauthenticateメソッドとほぼ同じ
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end

  # アカウントを有効にする
  def activate
    update_attribute(:activated, true)
    update_attribute(:activated_at, Time.zone.now)
  end

  # 有効化用のメールを送信する
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # パスワード再設定の属性を設定する
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest, User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  # パスワード再設定のメールを送信する
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # パスワード再設定の期限が切れている場合はtrueを返す
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  # 店舗の投稿をブックマークする
  def bookmark(shop)
    bookmarking << shop
  end

  # ブックマークを解除する
  def unbookmark(shop)
    bookmarks.find_by(shop_id: shop.id).destroy
  end

  # 現在のユーザーがブックマークしてたらtrueを返す
  def bookmarking?(shop)
    bookmarking.include?(shop)
  end

  private

  # メールアドレスを全て小文字にしてdbに保存する
  def downcase_email
    email.downcase!
  end

  # メール認証の有効化トークンとダイジェストを作成及び代入する
  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
