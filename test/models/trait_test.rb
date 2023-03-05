# == Schema Information
#
# Table name: traits
#
#  id          :uuid             not null, primary key
#  description :string
#  score       :integer
#  word        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require "test_helper"

class TraitTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
