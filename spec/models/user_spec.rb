# == Schema Information
#
# Table name: users
#
#  id              :uuid             not null, primary key
#  email           :string
#  password_digest :string
#  status          :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
require 'rails_helper'

RSpec.describe User, type: :model do

  it "has secure password" do
    pending
    fail
  end

  describe "scopes" do
    # The user model has no scopes
  end

  describe "attributes" do
    describe "#email" do
      it "is encrypted deterministically" do
        pending
        fail
      end
    end
    describe "#password_digest" do
      
    end
    describe "#status" do
      # Why is this attribute here?
    end
    it "contains no unexpected attributes" do
      expected_attributes = [
        :id,
        :email,
        :password_digest,
        :status,
        :created_at,
        :updated_at
      ]
      unexpected_attributes = User.new.attributes.keys.map(&:to_sym) - expected_attributes
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
    describe "#people" do
      
    end
    describe "#entries" do
      
    end
    describe "#pictures" do
      
    end
    describe "#notes" do
      
    end
    
  end

  describe "validations" do
    describe "#email" do
      it "must be present" do
        pending
        fail
      end
      it "must match the email regex" do
        pending
        fail
      end
      it "must be unique" do

      end
    end
  end
end
