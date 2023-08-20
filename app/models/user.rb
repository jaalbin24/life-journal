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

class User < ApplicationRecord
  has_secure_password
  include ImageValidation
  include Recoverable
  encrypts :email, deterministic: true, downcase: true
  validates :email, presence:         { message: "You'll need an email" }
  validates :email, email_format:     { message: "That's not an email" }
  validates :email, uniqueness:       { message: "That email is already taken" }
  validates :password, presence:      { message: "Your password can't be blank" }
  validates :password, confirmation:  { message: "The passwords don't match" }
  has_many :entries,  dependent: :destroy
  has_many :people,   dependent: :destroy
  has_many :pictures, dependent: :destroy
  has_many :notes,    dependent: :destroy, foreign_key: :user_id
  has_one_attached :avatar
  validate_images :avatar
end