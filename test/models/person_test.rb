# == Schema Information
#
# Table name: people
#
#  id            :uuid             not null, primary key
#  biography     :string
#  deleted       :boolean
#  deleted_at    :datetime
#  first_name    :string
#  gender        :string
#  last_name     :string
#  middle_name   :string
#  nickname      :string
#  notes         :string
#  title         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  created_by_id :uuid
#
# Indexes
#
#  index_people_on_created_by_id  (created_by_id)
#
# Foreign Keys
#
#  fk_rails_...  (created_by_id => users.id)
#
require "test_helper"

class PersonTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
