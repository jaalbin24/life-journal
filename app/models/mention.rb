# == Schema Information
#
# Table name: mentions
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  entry_id   :bigint
#  person_id  :bigint
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
    belongs_to(
        :person,
        class_name: "Person",
        foreign_key: :person_id,
        inverse_of: :mentions
    )

    belongs_to(
        :entry,
        class_name: "Entry",
        foreign_key: :entry_id,
        inverse_of: :mentions
    )
end
