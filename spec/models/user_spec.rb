# == Schema Information
#
# Table name: users
#
#  id                           :uuid             not null, primary key
#  deleted                      :boolean
#  deleted_at                   :datetime
#  email                        :string
#  password_digest              :string
#  remember_me_token            :string
#  remember_me_token_expires_at :datetime
#  status                       :string
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#
# Indexes
#
#  index_users_on_deleted            (deleted)
#  index_users_on_deleted_at         (deleted_at)
#  index_users_on_email              (email)
#  index_users_on_remember_me_token  (remember_me_token)
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
      it "is indexed in the database" do
        expect(ActiveRecord::Migration.index_exists?(:users, :email)).to be true
      end
    end
    describe "#remember_me_token" do
      it "is encrypted deterministically" do
        u = create :user
        remember_me_token = u.remember_me_token
        expect(User.encrypted_attributes).to include :remember_me_token
        # Models are only searchable on encrypted attributes when encrypted deterministically
        expect(User.find_by(remember_me_token: remember_me_token)).to eq u
      end
      it "preserves capitalization" do
        u = create :user
        remember_me_token = u.remember_me_token
        u.save
        expect(u.reload.remember_me_token).to eq remember_me_token
      end
      it "returns a string" do
        u = create :user
        expect(u.remember_me_token).to be_a String
      end
      it "is indexed in the database" do
        expect(ActiveRecord::Migration.index_exists?(:users, :remember_me_token)).to be true
      end
    end
    describe "remember_me_token_expires_at" do
      it "returns a ActiveSupport::TimeWithZone" do
        u = create :user
        expect(u.remember_me_token_expires_at).to be_a ActiveSupport::TimeWithZone
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
        :remember_me_token,
        :remember_me_token_expires_at,
        :created_at,
        :updated_at
      ]
      unexpected_attributes = User.new.attributes.keys.map(&:to_sym) - expected_attributes
      expect(unexpected_attributes).to be_empty, "Unexpected attributes found: #{unexpected_attributes.join(' ')}"
    end
  end

  describe "methods" do
    describe "#roll_remember_me_token" do
      it "sets remember_me_token_expires_at to 2 weeks from now" do
        u = create :user
        u.roll_remember_me_token
        expect(u.remember_me_token_expires_at).to be_within(1.second).of 2.weeks.from_now
      end
      it "calls SecureRandom.hex(16)" do
        u = create :user
        allow(SecureRandom).to receive(:hex).with(16).and_return('fake_secure_random_string')
        u.roll_remember_me_token
        expect(u.remember_me_token).to eq('fake_secure_random_string')
      end
      it "sets remember me token to a 32-character string" do
        u = create :user
        u.roll_remember_me_token
        expect(u.remember_me_token.size).to eq 32
      end
      context "if successful" do
        it "returns the new remember me token" do
          u = create :user
          expect(u.roll_remember_me_token).to eq u.remember_me_token
        end
      end
      context "if unsuccessful" do
        it "returns false" do
          u = create :user
          allow(u).to receive(:update).and_return(false) # Force a failure
          expect(u.roll_remember_me_token).to be false
        end
      end
    end
    describe "#remember_me_token_expired?" do
      it "returns false if remember_me_token_expires_at is in the future" do
        u = build :user
        u.remember_me_token_expires_at = 1.year.from_now
        expect(u.remember_me_token_expired?).to be false
      end
      it "returns true if remember_me_token_expires_at is in the past" do
        u = build :user
        u.remember_me_token_expires_at = 1.year.ago
        expect(u.remember_me_token_expired?).to be true
      end
    end
  end

  describe "class methods" do
    # The user model currently has no class methods to test
  end

  describe "callbacks" do
    describe "after_commit" do
      describe "on create" do
        it "calls #roll_remember_token" do
          u = build :user
          expect(u).to receive(:roll_remember_me_token)
          u.save
        end
      end
    end
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
    describe "#password" do
      it "must be present when creating a record" do
        u = build :user, password: ""
        expect(u.save).to be false
        expect(u.errors[:password].empty?).to be false
      end
      it "must be present when updating the email attribute" do
        pending
        fail
      end
    end
    describe "#password_confirmation" do
      it "must be present when creating a record" do
        u = build :user, password_confirmation: ""
        expect(u.save).to be false
        expect(u.errors[:password_confirmation].empty?).to be false
      end
      it "must be present when updating the email attribute" do
        pending
        fail
      end
    end
    describe "password_digest" do
      it "must be present always" do
        u = build :user, password_digest: ""
        expect(u.save).to be false
        u = create :user
        expect(u.update(password_digest: "")).to be false
      end
    end
  end
end
