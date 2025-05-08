class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product
  has_many :products, through: :order_items

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 1 }
  validates :amount_cents, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 100 }
end
