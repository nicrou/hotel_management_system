class Category < ApplicationRecord
  has_many :rooms, dependent: :destroy
  validates :title, presence: true, uniqueness: true
  validates :rooms_count, presence: true, numericality: { only_integer: true }
  validates :price, presence: true, numericality: true
  validates :discount, numericality: true

  monetize :price_cents
end
