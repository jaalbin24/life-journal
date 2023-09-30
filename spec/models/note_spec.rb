# == Schema Information
#
# Table name: notes
#
#  id         :uuid             not null, primary key
#  content    :string
#  deleted    :boolean
#  deleted_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  person_id  :uuid             not null
#  user_id    :uuid             not null
#
# Indexes
#
#  index_notes_on_deleted     (deleted)
#  index_notes_on_deleted_at  (deleted_at)
#  index_notes_on_person_id   (person_id)
#  index_notes_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (person_id => people.id)
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
    it { should belong_to :person }
    it { should belong_to :user }
    it "contains no unexpected attributes" do
      expected_attributes = [
        :id,
        :content,
        :user_id,
        :person_id,
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
    it { should validate_presence_of(:content).with_message("The note has to say something") }
  end
end
