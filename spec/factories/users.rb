# == Schema Information
#
# Table name: users
#
#  id                           :uuid             not null, primary key
#  deleted                      :boolean
#  deleted_at                   :datetime
#  email                        :string
#  password_digest              :string
#  remember_me_token            :string
#  remember_me_token_expires_at :datetime
#  status                       :string
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#
# Indexes
#
#  index_users_on_deleted            (deleted)
#  index_users_on_deleted_at         (deleted_at)
#  index_users_on_email              (email)
#  index_users_on_remember_me_token  (remember_me_token)
#
FactoryBot.define do
  factory :user do
    sequence :email do |i|
      "user#{i}@example.com"
    end
    password { "password123" }
    password_confirmation { "password123" }

    trait :deleted do
      deleted { true }
      deleted_at { 23.hours.ago }
    end

    trait :with_avatar do
      avatar { Rack::Test::UploadedFile.new(Dir.glob("#{Rails.root.join('db', 'seed_data', 'avatars')}/*.jpeg").sample, 'image/jpeg') }
    end
  end
end
