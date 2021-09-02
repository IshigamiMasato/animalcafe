class Review < ApplicationRecord
  belongs_to :user
  belongs_to :shop
  validates :content, length: { maximum: 255 }
  validates :score, presence: true

  # reviewの並び順
  default_scope -> { order(created_at: :desc) }
end
