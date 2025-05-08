FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { "password123" }
    password_confirmation { "password123" }
    name { "John Doe" }
    birthday { Faker::Date.between(from: "1950/01/01", to: "2001/12/31") }
    gender { :other }
    address { Faker::Address.full_address }
    role { :customers }
  end
end
