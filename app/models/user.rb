# == Schema Information
#
# Table name: users
#
#  id        :uuid       not null, primary key
#  email       :string
#  password_digest :string
#  status      :string
#  created_at    :datetime     not null
#  updated_at    :datetime     not null
#
class User < ApplicationRecord
  enum status: { regular: 0, admin: 1000 } 
  encrypts :email, deterministic: true, downcase: true
  validates :email, presence: { message: "You'll need an email" }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: "That's not an email" }
  validates :email, uniqueness: { message: "That email is already taken" }
  validates :password, presence: { message: "Your password can't be blank" }
  validates :password, confirmation: { message: "The passwords don't match" }
  has_secure_password
  has_many(
    :entries,
    class_name: "Entry",
    foreign_key: :user_id,
    inverse_of: :user,
    dependent: :destroy
  )
  has_many(
    :people,
    class_name: "Person",
    foreign_key: :user_id,
    inverse_of: :user,
    dependent: :destroy
  )
  has_many :lessons
  has_many :milestones
  has_many :pictures
  has_many :notes, foreign_key: :user_id

end
