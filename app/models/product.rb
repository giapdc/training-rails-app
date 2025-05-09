class Product < ApplicationRecord
  belongs_to :category

  validates :name, presence: true
  validates :amount_cents, presence: true, numericality: { greater_than_or_equal_to: 100 }
end
