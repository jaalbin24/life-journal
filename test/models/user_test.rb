# == Schema Information
#
# Table name: users
#
#  id              :uuid             not null, primary key
#  deleted         :boolean
#  deleted_at      :datetime
#  email           :string
#  password_digest :string
#  status          :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
require "test_helper"

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
