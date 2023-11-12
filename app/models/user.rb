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
#  time_zone                       :string           default("UTC")
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

class User < ApplicationRecord
  has_secure_password
  include ImageValidation
  include Recoverable
  encrypts :email, deterministic: true, downcase: true
  encrypts :stay_signed_in_token, deterministic: true
  validates :email, presence:         { message: "You'll need an email" },
                    email_format:     { message: "That's not an email" },
                    uniqueness:       {
                      message: "That email is already taken",
                      case_sensitive: true
                    }
  validate :password_challenge_provided, on: :update
  has_many :entries,  dependent: :destroy
  has_many :people,   dependent: :destroy
  has_many :notes,    dependent: :destroy, foreign_key: :user_id
  has_many :mentions, dependent: :destroy
  has_many :chats,    dependent: :destroy
  has_many :messages, dependent: :destroy
  has_one_attached :avatar
  validate_images :avatar

  after_commit :roll_stay_signed_in_token, on: :create

  def roll_stay_signed_in_token
    update_params = {
      stay_signed_in_token:            SecureRandom.hex(16),
      stay_signed_in_token_expires_at: 2.weeks.from_now
    }
    if self.update(update_params)
      stay_signed_in_token
    else
      false
    end
  end

  def stay_signed_in_token_expired?
    stay_signed_in_token_expires_at <= DateTime.current
  end

  def change_password(old_password, new_password)
    if self.authenticate old_password
      self.update(password: new_password)
    else
      false
    end
  end

  attr_accessor :password_challenge
  
  private
  
  # Based on the code found at
  # https://github.com/rails/rails/blob/42db7f307f9cc1fb0cc5da68c830d08f625429cf/activemodel/lib/active_model/secure_password.rb#L125
  def password_challenge_provided
    # Changing the email or password requires the password
    if email_changed? || password_digest_changed?
      unless password_digest_was.present? && BCrypt::Password.new(password_digest_was).is_password?(password_challenge)
        if password_challenge.blank?
          errors.add(:password_challenge, "Your password is required")
        else
          errors.add(:password_challenge, "Incorrect password")
        end
      end
    end
  end
end
