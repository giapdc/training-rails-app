FactoryBot.define do
  factory :order_item do
    association :order
    association :product
    quantity { 10 }
    amount_cents { product.amount_cents }
  end
end
