# == Schema Information
#
# Table name: lessons
#
#  id         :uuid             not null, primary key
#  content    :string
#  deleted    :boolean
#  deleted_at :datetime
#  status     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  person_id  :uuid
#  user_id    :uuid             not null
#
# Indexes
#
#  index_lessons_on_person_id  (person_id)
#  index_lessons_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (person_id => people.id)
#  fk_rails_...  (user_id => users.id)
#
require "test_helper"

class LessonTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
