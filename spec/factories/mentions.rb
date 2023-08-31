# == Schema Information
#
# Table name: mentions
#
#  id         :uuid             not null, primary key
#  added_by   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  entry_id   :uuid
#  person_id  :uuid
#  user_id    :uuid
#
# Indexes
#
#  index_mentions_on_entry_id   (entry_id)
#  index_mentions_on_person_id  (person_id)
#  index_mentions_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (entry_id => entries.id)
#  fk_rails_...  (person_id => people.id)
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
    factory :mention do
      association :person
      association :entry

      # Create associated records if they aren't already created
      after :build do |mention, evaluator|
        user = mention.entry&.user
        user ||= mention.person&.user
        mention.person = build(:person, user: user) if mention.person.nil?
        mention.entry = build(:entry, user: user) if mention.entry.nil?
      end
    end
  end
