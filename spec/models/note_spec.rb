# == Schema Information
#
# Table name: notes
#
#  id           :uuid             not null, primary key
#  content      :string
#  deleted      :boolean
#  deleted_at   :datetime
#  notable_type :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  notable_id   :uuid             not null
#  user_id      :uuid             not null
#
# Indexes
#
#  index_notes_on_deleted     (deleted)
#  index_notes_on_deleted_at  (deleted_at)
#  index_notes_on_notable     (notable_type,notable_id)
#  index_notes_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Note, type: :model do
  describe "scopes" do
  end

  describe "attributes" do

  end

  describe "methods" do

  end

  describe "callbacks" do

  end

  describe "associations" do
    it "contains no unexpected attributes" do
      expected_attributes = [
        :id,
        :content,
        :user_id,
        :notable_type,
        :notable_id,
        :deleted,
        :deleted_at,
        :created_at,
        :updated_at
      ]
      unexpected_attributes = Note.new.attributes.keys.map(&:to_sym) - expected_attributes
      expect(unexpected_attributes).to be_empty, "Unexpected attributes found: #{unexpected_attributes.join(' ')}"
    end
  end

  describe "validations" do

  end
end
