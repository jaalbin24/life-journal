# == Schema Information
#
# Table name: pictures
#
#  id          :uuid             not null, primary key
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  entry_id    :uuid             not null
#
# Indexes
#
#  index_pictures_on_entry_id  (entry_id)
#
# Foreign Keys
#
#  fk_rails_...  (entry_id => entries.id)
#
require "test_helper"

class PictureTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
