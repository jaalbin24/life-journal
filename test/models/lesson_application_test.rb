# == Schema Information
#
# Table name: lesson_applications
#
#  id         :uuid             not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  entry_id   :uuid             not null
#  lesson_id  :uuid             not null
#
# Indexes
#
#  index_lesson_applications_on_entry_id   (entry_id)
#  index_lesson_applications_on_lesson_id  (lesson_id)
#
# Foreign Keys
#
#  fk_rails_...  (entry_id => entries.id)
#  fk_rails_...  (lesson_id => lessons.id)
#
require "test_helper"

class LessonApplicationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
