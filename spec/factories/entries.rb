# == Schema Information
#
# Table name: entries
#
#  id            :uuid             not null, primary key
#  content       :string
#  content_plain :string
#  deleted       :boolean
#  deleted_at    :datetime
#  published_at  :datetime
#  status        :string
#  title         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id     :uuid
#
# Indexes
#
#  index_entries_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :entry do
    association :user, factory: :user
    title { "Test Title" }
    content { ActionText::Content.new(Faker::Lorem.paragraphs.join("\n\n")) }

    trait :published do
      status { "published" }
    end
    trait :draft do
      status { "draft" }
    end
    trait :deleted do
      deleted { true }
    end
    trait :empty do
      title { nil }
      content { nil }
    end

    transient do
      num_pictures { 0 } # Sets the number of pictures to be created alongside the entry
      num_mentions { 0 } # Sets the number of mentions to be created alongside the entry
    end

    # Create associated records
    after(:create) do |entry, evaluator|
      create_list(:picture, evaluator.num_pictures, entry: entry, user: entry.user)
      create_list(:mention, evaluator.num_mentions, entry: entry)
    end
  end
end
  
