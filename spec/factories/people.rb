# == Schema Information
#
# Table name: people
#
#  id          :uuid             not null, primary key
#  biography   :string
#  deleted     :boolean
#  deleted_at  :datetime
#  first_name  :string
#  gender      :string
#  last_name   :string
#  middle_name :string
#  nickname    :string
#  notes       :string
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :uuid
#
# Indexes
#
#  index_people_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :person do
    first_name { "John" }

    trait :with_avatar do
      avatar { Rack::Test::UploadedFile.new(Dir.glob("#{Rails.root.join('db', 'seed_data', 'avatars')}/*").sample, 'image/jpeg') }
    end

    trait :deleted do
      deleted { true }
      deleted_at { 23.hours.ago }
    end
  
    after :build do |person, evaluator|
      person.user = build(:user) if person.user.nil?
    end

    before :create do |person, evaluator|
      person.user = create(:user) if person.user.nil?
      person.user.save
    end
  end
end
