# == Schema Information
#
# Table name: personalities
#
#  id         :uuid             not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  person_id  :uuid             not null
#  trait_id   :uuid             not null
#
# Indexes
#
#  index_personalities_on_person_id  (person_id)
#  index_personalities_on_trait_id   (trait_id)
#
# Foreign Keys
#
#  fk_rails_...  (person_id => people.id)
#  fk_rails_...  (trait_id => traits.id)
#
require 'rails_helper'

RSpec.describe Personality, type: :model do
  describe "scopes" do
    # This model does not have any scopes.
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
    it "contains no unexpected attributes" do
      expected_attributes = [
        :id,
        :person_id
        :trait_id,
        :created_at,
        :updated_at
      ]
      unexpected_attributes = Personality.new.attributes.keys.map(&:to_sym) - expected_attributes
      expect(unexpected_attributes).to be_empty, "Unexpected attributes found: #{unexpected_attributes.join(' ')}"
    end
  end

  describe "validations" do
    it do
      pending
      fail
    end
  end
end
