class Order < ApplicationRecord
  extend Enumerize

  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items, source: :product

  enumerize :currency, in: { USD: "usd", JPY: "jpy" }, default: :USD, predicates: true, scope: true

  validates :currency, presence: true
  validates :total_amount_cents, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
