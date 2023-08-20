# == Schema Information
#
# Table name: notes
#
#  id           :uuid             not null, primary key
#  content      :string
#  deleted      :boolean
#  deleted_at   :datetime
#  notable_type :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  notable_id   :uuid             not null
#  user_id      :uuid             not null
#
# Indexes
#
#  index_notes_on_notable  (notable_type,notable_id)
#  index_notes_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :note do
    for_person # Default to the for_person trait

    association :user
    content { "Test note" }

    trait :for_person do
      association :notable, factory: :person
    end
  end
end
