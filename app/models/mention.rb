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
class Mention < ApplicationRecord
    belongs_to :person
    belongs_to :entry
end
