# == Schema Information
#
# Table name: users
#
#  id              :uuid             not null, primary key
#  email           :string
#  password_digest :string
#  status          :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
FactoryBot.define do
  factory :user do
    sequence :email do |i|
      "user#{i}@example.com"
    end
    password { "password123" }
    password_confirmation { "password123" }
  end
end
