# == Schema Information
#
# Table name: pictures
#
#  id          :uuid             not null, primary key
#  deleted     :boolean
#  deleted_at  :datetime
#  description :string
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  entry_id    :uuid             not null
#  user_id     :uuid             not null
#
# Indexes
#
#  index_pictures_on_entry_id  (entry_id)
#  index_pictures_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (entry_id => entries.id)
#  fk_rails_...  (user_id => users.id)
#

FactoryBot.define do
  factory :picture do
    association :user
    association :entry
    file { Rack::Test::UploadedFile.new(Dir.glob("#{Rails.root.join('db', 'seed_data', 'entry_pictures')}/*").sample, 'image/jpeg') }
    
    trait :deleted do
      deleted { true }
      deleted_at { 23.hours.ago }
    end
  end
end