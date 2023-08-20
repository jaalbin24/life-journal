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
        email = "CAPITAL.letters@eXaMpLe.Com"
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
      it "is a has_many relationship" do
        expect(User.reflect_on_association(:people).macro).to eq(:has_many)
      end
      it "are destroyed when the user is destroyed" do
        u = create :user
        u.people = create_list(:person, 2, user: u)
        expect(Person.count).to be 2
        u.destroy
        expect(Person.count).to be 0
      end
    end
    describe "#entries" do
      it "is a has_many relationship" do
        expect(User.reflect_on_association(:entries).macro).to eq(:has_many)
      end
      it "are destroyed when the user is destroyed" do
        u = create :user
        u.entries = create_list(:entry, 2, user: u)
        expect(Entry.count).to be 2
        u.destroy
        expect(Entry.count).to be 0
      end
    end
    describe "#pictures" do
      it "is a has_many relationship" do
        expect(User.reflect_on_association(:pictures).macro).to eq(:has_many)
      end
      it "are destroyed when the user is destroyed" do
        u = create :user
        u.pictures = create_list(:picture, 2, user: u)
        expect(Picture.count).to be 2
        u.destroy
        expect(Picture.count).to be 0
      end
    end
    describe "#notes" do
      it "is a has_many relationship" do
        expect(User.reflect_on_association(:notes).macro).to eq(:has_many)
      end
      it "are destroyed when the user is destroyed" do
        u = create :user
        u.notes = create_list(:note, 2, user: u)
        expect(Note.count).to be 2
        u.destroy
        expect(Note.count).to be 0
      end
    end
    describe "#avatar" do
      it "is a has_one_attached relationship" do
        expect(User.new.avatar).to be_an_instance_of(ActiveStorage::Attached::One)
      end
      it "is destroyed when the user is destroyed" do
        u = create :user, :with_avatar
        expect(u.avatar).to be_attached
        u.destroy
        expect(u.avatar.persisted?).to be false
      end
    end
  end

  describe "validations" do
    describe "#email" do
      it "must be present" do
        u = build :user, email: ""
        expect(u.valid?).to be false
        expect(u.errors[:email]).to include "You'll need an email"
        u.email = "email@example.com"
        expect(u.valid?).to be true
      end
      it "must be an email" do
        invalid_emails = [
          "plainaddress",             # Missing "@" symbol
          "@domain.com",              # Missing local part
          "user@",                    # Missing domain
          "user@domain",              # Incomplete domain
          "user@.com",                # Missing domain name
          "user@domain.",             # Domain ends with a dot
          "user@dom ain.com",         # Spaces not allowed
          "user@domain.com@",         # "@" at the end
          "user@domain..com",         # Double dot in domain
          "user@-domain.com",         # Domain starts with a hyphen
          "user@domain.c",            # TLD less than 2 characters
          "user@.domain.com",         # Empty local part
          "user@domain.com.",         # Trailing dot in domain
          "user@domain..com",         # Consecutive dots in domain
          "user@.domain.com",         # Leading dot in domain
          "user@domain.c.o.m",        # Multiple dots in TLD
          "user@-domain.com",         # Leading hyphen in domain
          "user@123.456.789.000",     # IP address format
          "user@dom_ain.com",         # Underscore in domain
          "user@domain.c_om",         # Underscore in TLD
          "user@domain.com_",         # Underscore at the end
          "user@[domain.com]",        # Square brackets
          "user@domain..com",         # Consecutive dots in local part
          "user@domain.123",          # Numeric TLD
          "user@.123.com",            # Leading dot in TLD
          "user@domain.c",            # TLD with only one character
          "user@",                    # Empty local part and domain
          "user@.com",                # Empty local part
          "@domain.com",              # Empty local part with "@" prefix
          "user@-example.com",        # Hyphen as the first character in domain
          "user@ex_ample.com",        # Underscore in domain
        ]
        u = create :user
        expect(u.valid?).to be true
        invalid_emails.each do |email|
          u.email = email
          expect(u.valid?).to be(false), "#{email} was validated when it should not have been"
          expect(u.errors[:email]).to include "That's not an email"
        end
      end
      it "must be unique" do
        email = "test@example.com"
        u1 = create :user, email: email
        u2 = build :user
        expect(u2.valid?).to be true
        u2.email = email
        expect(u2.valid?).to be false
      end
    end
  end
end
