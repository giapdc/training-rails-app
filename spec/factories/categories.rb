FactoryBot.define do
  factory :category do
    sequence(:name) { |n| "Category #{n}" }
    description { "This is a sample category description." }
  end
end
