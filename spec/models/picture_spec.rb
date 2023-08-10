# == Schema Information
#
# Table name: pictures
#
#  id          :uuid             not null, primary key
#  deleted     :boolean
#  deleted_at  :datetime
#  description :string
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  entry_id    :uuid             not null
#  user_id     :uuid             not null
#
# Indexes
#
#  index_pictures_on_entry_id  (entry_id)
#  index_pictures_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (entry_id => entries.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Picture, type: :model do
  describe "scopes" do
    it do
      pending
      fail
    end
  end

  describe "attributes" do
    it do
      pending
      fail
    end
  end

  describe "methods" do
    it do
      pending
      fail
    end
  end

  describe "callbacks" do
    it do
      pending
      fail
    end
  end

  describe "associations" do
    it do
      pending
      fail
    end
  end

  describe "validations" do
    it do
      pending
      fail
    end
  end
end