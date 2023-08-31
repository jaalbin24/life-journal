# == Schema Information
#
# Table name: users
#
#  id                              :uuid             not null, primary key
#  deleted                         :boolean
#  deleted_at                      :datetime
#  email                           :string
#  password_digest                 :string
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

class User < ApplicationRecord
  has_secure_password
  include ImageValidation
  include Recoverable
  encrypts :email, deterministic: true, downcase: true
  encrypts :stay_signed_in_token, deterministic: true
  validates :email, presence:         { message: "You'll need an email" }
  validates :email, email_format:     { message: "That's not an email" }
  validates :email, uniqueness:       { message: "That email is already taken" }
  validates :password, presence:      { message: "Your password can't be blank" }, on: :create
  validates :password, confirmation:  { message: "The passwords don't match" }
  has_many :entries,  dependent: :destroy
  has_many :people,   dependent: :destroy
  has_many :pictures, dependent: :destroy
  has_many :notes,    dependent: :destroy, foreign_key: :user_id
  has_many :mentions
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
end
