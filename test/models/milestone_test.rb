# == Schema Information
#
# Table name: milestones
#
#  id         :uuid             not null, primary key
#  content    :string
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
require "test_helper"

class MilestoneTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
