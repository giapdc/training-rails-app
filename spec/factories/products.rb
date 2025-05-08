FactoryBot.define do
  factory :product do
    sequence(:name) { |n| "Product #{n}" }
    amount_cents { rand(100..10_000) }
    association :category
  end
end
