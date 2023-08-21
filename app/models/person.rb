# == Schema Information
#
# Table name: people
#
#  id          :uuid             not null, primary key
#  biography   :string
#  deleted     :boolean
#  deleted_at  :datetime
#  first_name  :string
#  gender      :string
#  last_name   :string
#  middle_name :string
#  nickname    :string
#  notes       :string
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :uuid
#
# Indexes
#
#  index_people_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#


class Person < ApplicationRecord
  include Recoverable
  include ImageValidation
  include Searchable
  searches :first_name, :last_name, :middle_name, :nickname
  paginates_per 24
  encrypts :first_name, :last_name, :middle_name, :nickname, :gender, :title, deterministic: true
  encrypts :biography
  has_one_attached :avatar
  has_many(
    :mentions,
    class_name: "Mention",
    foreign_key: :person_id,
    inverse_of: :person,
    dependent: :destroy
  )
  has_many :entries, through: :mentions
  has_many :personality
  has_many :notes, as: :notable
  has_many :traits, through: :personality

  belongs_to :user
  validates :name, presence: true
  validate_images :avatar

  def name
    [(nickname.blank? ? first_name : nickname), last_name].reject(&:blank?).join(" ").titleize
  end

  def full_name
    # This strange formatting of title in the first element keeps the starting character in the
    # Person's title capitalized while leaving the rest of the characters well alone. This is done
    # to prevent words like "CEO" becoming "Ceo when using a simple title.titleize"
    [("#{title[0].capitalize}#{title[1..-1]}" if title), first_name&.titleize, middle_name&.titleize, last_name&.titleize].reject(&:blank?).join(" ")
  end

  def show_path
    Rails.application.routes.url_helpers.person_path(self)
  end

  def avatar_url
    if avatar.attached?
      Rails.application.routes.url_helpers.url_for(self.avatar)
    else
      ActionController::Base.helpers.image_url('default_profile_picture.png')
    end
  end
end
