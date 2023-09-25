# == Schema Information
#
# Table name: users
#
#  id                              :uuid             not null, primary key
#  deleted                         :boolean
#  deleted_at                      :datetime
#  email                           :string
#  password_digest                 :string
#  signed_in_at                    :datetime
#  status                          :string
#  stay_signed_in_token            :string
#  stay_signed_in_token_expires_at :datetime
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#
# Indexes
#
#  index_users_on_deleted               (deleted)
#  index_users_on_deleted_at            (deleted_at)
#  index_users_on_email                 (email)
#  index_users_on_stay_signed_in_token  (stay_signed_in_token)
#
require 'rails_helper'
require 'models/concerns/image_validation'
require 'models/concerns/recoverable'

RSpec.describe User, type: :model do

  it_behaves_like ImageValidation,  User
  it_behaves_like Recoverable,      User

  it { should have_secure_password }

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
      # Emails must be saved in lowercase to avoid collisions
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
      it { should have_db_index(:email) }
    end
    describe "#stay_signed_in_token" do
      it "is encrypted deterministically" do
        u = create :user
        stay_signed_in_token = u.stay_signed_in_token
        expect(User.encrypted_attributes).to include :stay_signed_in_token
        # Models are only searchable on encrypted attributes when encrypted deterministically
        expect(User.find_by(stay_signed_in_token: stay_signed_in_token)).to eq u
      end
      it "preserves capitalization" do
        u = create :user
        stay_signed_in_token = u.stay_signed_in_token
        u.save
        expect(u.reload.stay_signed_in_token).to eq stay_signed_in_token
      end
      it "returns a string" do
        u = create :user
        expect(u.stay_signed_in_token).to be_a String
      end
      it { should have_db_index(:stay_signed_in_token) }
    end
    describe "stay_signed_in_token_expires_at" do
      it "returns a ActiveSupport::TimeWithZone" do
        u = create :user
        expect(u.stay_signed_in_token_expires_at).to be_a ActiveSupport::TimeWithZone
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
        :stay_signed_in_token,
        :stay_signed_in_token_expires_at,
        :signed_in_at,
        :created_at,
        :updated_at
      ]
      unexpected_attributes = User.new.attributes.keys.map(&:to_sym) - expected_attributes
      expect(unexpected_attributes).to be_empty, "Unexpected attributes found: #{unexpected_attributes.join(' ')}"
    end
  end

  describe "methods" do
    describe "#roll_stay_signed_in_token" do
      it "sets stay_signed_in_token_expires_at to 2 weeks from now" do
        u = create :user
        u.roll_stay_signed_in_token
        expect(u.stay_signed_in_token_expires_at).to be_within(1.second).of 2.weeks.from_now
      end
      it "calls SecureRandom.hex(16)" do
        u = create :user
        allow(SecureRandom).to receive(:hex).with(16).and_return('fake_secure_random_string')
        u.roll_stay_signed_in_token
        expect(u.stay_signed_in_token).to eq('fake_secure_random_string')
      end
      it "sets stay signed in token to a 32-character string" do
        u = create :user
        u.roll_stay_signed_in_token
        expect(u.stay_signed_in_token.size).to eq 32
      end
      context "if successful" do
        it "returns the new stay signed in token" do
          u = create :user
          expect(u.roll_stay_signed_in_token).to eq u.stay_signed_in_token
        end
      end
      context "if unsuccessful" do
        it "returns false" do
          u = create :user
          allow(u).to receive(:update).and_return(false) # Force a failure
          expect(u.roll_stay_signed_in_token).to be false
        end
      end
    end
    describe "#stay_signed_in_token_expired?" do
      it "returns false if stay_signed_in_token_expires_at is in the future" do
        u = build :user
        u.stay_signed_in_token_expires_at = 1.year.from_now
        expect(u.stay_signed_in_token_expired?).to be false
      end
      it "returns true if stay_signed_in_token_expires_at is in the past" do
        u = build :user
        u.stay_signed_in_token_expires_at = 1.year.ago
        expect(u.stay_signed_in_token_expired?).to be true
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
          expect(u).to receive(:roll_stay_signed_in_token)
          u.save
        end
      end
    end
  end


  describe "associations" do
    it { should have_many(:people).dependent(:destroy) }
    it { should have_many(:entries).dependent(:destroy) }
    it { should have_many(:notes).dependent(:destroy) }
    it { should have_one_attached(:avatar) }
  end

  describe "validations" do
    describe "#email" do
      invalid_emails = [
        "",                         # It's blank
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
      ].each do |email|
        it { should_not allow_value(email).for(:email) }
      end
      it { should validate_uniqueness_of(:email).ignoring_case_sensitivity.with_message('That email is already taken') }
    end
    it { should validate_presence_of(:password).on(:create) }
    it { should validate_confirmation_of(:password).with_message("The passwords don't match") }
    describe "#password_confirmation" do
      it "must be present when updating the email attribute" do
        pending
        fail
      end
    end
  end
end
