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
require 'rails_helper'
require 'models/concerns/image_validation'
require 'models/concerns/recoverable'

RSpec.describe User, type: :model do

  it_behaves_like ImageValidation,  User
  it_behaves_like Recoverable,      User
  it { is_expected.to have_many(:entries) }


  it "has a secure password" do
    u = build(:user)
    expect(u).to respond_to(:password_digest)
    expect(u).to respond_to(:password)
    expect(u).to respond_to(:password_confirmation)
    expect(u).to respond_to(:authenticate)
    expect(u).to be_valid
  end

  describe "scopes" do
    # The user model has no scopes
  end

  describe "attributes" do
    describe "#email" do
      it "is encrypted deterministically" do
        email = "searchable@example.com"
        u = create :user, email: email
        expect(User.encrypted_attributes).to include :email
        # Models are only searchable on encrypted attributes when encrypted deterministically
        expect(User.find_by(email: email)).to eq u
      end
      it "is saved in lowercase" do
        email = "CAPITAL.letters.@eXaMpLe.Com"
        u = build :user, email: email
        u.save
        expect(u.reload.email).to eq email.downcase
      end
      it "returns a string" do
        u = create :user
        expect(u.email).to be_a String
      end
    end
    it "contains no unexpected attributes" do
      # Before adding anything to the expected attributes array, be sure you've written tests for the new attribute
      expected_attributes = [
        :id,
        :email,
        :password_digest,
        :status,
        :deleted,
        :deleted_at,
        :created_at,
        :updated_at
      ]
      unexpected_attributes = User.new.attributes.keys.map(&:to_sym) - expected_attributes
      expect(unexpected_attributes).to be_empty, "Unexpected attributes found: #{unexpected_attributes.join(' ')}"
    end
  end

  describe "methods" do
    # The user model currently has no instance methods to test
  end

  describe "class methods" do
    # The user model currently has no class methods to test
  end

  describe "callbacks" do
    # The user model currently has no callbacks to test
  end

  describe "associations" do
    describe "#people" do
      it "are destroyed when the user is destroyed" do
        pending
        fail
      end
    end
    describe "#entries" do
      it "are destroyed when the user is destroyed" do
        pending
        fail
      end
    end
    describe "#pictures" do
      it "are destroyed when the user is destroyed" do
        pending
        fail
      end
    end
    describe "#notes" do
      it "are destroyed when the user is destroyed" do
        pending
        fail
      end
    end
    describe "#avatar" do
      it "is destroyed when the user is destroyed" do
        pending
        fail
      end
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
        pending
        fail
      end
    end
  end
end
