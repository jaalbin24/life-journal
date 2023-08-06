# == Schema Information
#
# Table name: mentions
#
#  id         :uuid             not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  entry_id   :uuid
#  person_id  :uuid
#
# Indexes
#
#  index_mentions_on_entry_id   (entry_id)
#  index_mentions_on_person_id  (person_id)
#
# Foreign Keys
#
#  fk_rails_...  (entry_id => entries.id)
#  fk_rails_...  (person_id => people.id)
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
