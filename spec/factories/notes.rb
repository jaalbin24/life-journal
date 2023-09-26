# == Schema Information
#
# Table name: notes
#
#  id         :uuid             not null, primary key
#  content    :string
#  deleted    :boolean
#  deleted_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  person_id  :uuid             not null
#  user_id    :uuid             not null
#
# Indexes
#
#  index_notes_on_deleted     (deleted)
#  index_notes_on_deleted_at  (deleted_at)
#  index_notes_on_person_id   (person_id)
#  index_notes_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (person_id => people.id)
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :note do
    association :person

    association :user
    content { "Test note" }
  end
end
