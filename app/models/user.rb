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
  validates :email, presence: { message: "You'll need an email" }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: "That's not an email" }
  validates :email, uniqueness: { message: "That email is already taken" }
  validates :password, presence: { message: "Your password can't be blank" }
  validates :password, confirmation: { message: "The passwords don't match" }
  has_many :entries
  has_many :people
  has_many :lessons
  has_many :milestones
  has_many :pictures
  has_many :notes, foreign_key: :user_id
  has_one_attached :avatar
  validate_images :avatar
end
