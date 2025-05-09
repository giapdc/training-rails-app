FactoryBot.define do
  factory :order do
    association :user
    total_amount_cents { 1000 }
  end
end
