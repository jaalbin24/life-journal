# == Schema Information
#
# Table name: people
#
#  id         :bigint           not null, primary key
#  age        :integer
#  first_name :string
#  last_name  :string
#  sex        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "test_helper"

class PersonTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
