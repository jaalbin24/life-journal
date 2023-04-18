FactoryBot.define do
  factory :user do
    sequence :email do |i|
      "user#{i}@example.com"
    end
    password { "password123" }
    password_confirmation { "password123" }
  end
end