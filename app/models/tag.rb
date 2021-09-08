class Tag < ApplicationRecord
  has_many :tag_maps, dependent: :destroy
  has_many :shops, through: :tag_maps

  validates :name, presence: true, length: { maximum: 15 }
  validates :tag_type, presence: true
end
