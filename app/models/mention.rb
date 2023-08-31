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
class Mention < ApplicationRecord
  belongs_to :user
  belongs_to :person
  belongs_to :entry

  before_validation on: :create do
    init_user
    init_added_by
  end

  def added_by_user?
    added_by == "user"
  end

  private

  def init_added_by
    self.added_by ||= "user"
  end

  def init_user
    self.user ||= entry.user
    self.user ||= person.user
  end
end
