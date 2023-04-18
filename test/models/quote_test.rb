# == Schema Information
#
# Table name: quotes
#
#  id         :uuid             not null, primary key
#  author     :string
#  content    :string
#  deleted    :boolean
#  deleted_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "test_helper"

class QuoteTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
