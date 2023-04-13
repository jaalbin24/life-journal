# == Schema Information
#
# Table name: milestones
#
#  id         :uuid             not null, primary key
#  content    :string
#  deleted    :boolean
#  deleted_at :datetime
#  reached_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  entry_id   :uuid             not null
#  user_id    :uuid             not null
#
# Indexes
#
#  index_milestones_on_entry_id  (entry_id)
#  index_milestones_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (entry_id => entries.id)
#  fk_rails_...  (user_id => users.id)
#
class Milestone < ApplicationRecord
  belongs_to :entry
  belongs_to :user
end
