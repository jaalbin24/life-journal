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
require 'models/concerns/image_validation'

RSpec.describe Picture, type: :model do

  it_behaves_like ImageValidation,  Picture
  it_behaves_like Recoverable,      Picture

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
    it "contains no unexpected attributes" do
      expected_attributes = [
        :id,
        :description,
        :title,
        :entry_id,
        :user_id,
        :deleted,
        :deleted_at,
        :created_at,
        :updated_at
      ]
      unexpected_attributes = Picture.new.attributes.keys.map(&:to_sym) - expected_attributes
      expect(unexpected_attributes).to be_empty, "Unexpected attributes found: #{unexpected_attributes.join(' ')}"
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
