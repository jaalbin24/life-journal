# == Schema Information
#
# Table name: people
#
#  id            :uuid             not null, primary key
#  biography     :string
#  deleted       :boolean
#  deleted_at    :datetime
#  first_name    :string
#  gender        :string
#  last_name     :string
#  middle_name   :string
#  nickname      :string
#  notes         :string
#  title         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id :uuid
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
  paginates_per 24
  include Recoverable
  include ImageValidation
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
  has_many(
    :entries,
    through: :mentions
  )
  has_many :personality
  has_many :lessons
  has_many :notes, as: :notable
  has_many :traits, through: :personality

  belongs_to(
    :user,
    class_name: "User",
    foreign_key: :user_id,
    inverse_of: :people
  )
  validates :name, presence: true
  validate  ->  (p)  {file_is_img(:avatar)}


  def name
    [(nickname.blank? ? first_name : nickname), last_name].reject(&:blank?).join(" ")
  end

  def self.search(params)
    result = self.all
    if params[:name].include?(' ')
      first_name, last_name = params[:name].downcase.split(' ')
      result = result.where("LOWER(first_name) LIKE ? OR LOWER(last_name) LIKE ?", "%#{ActiveRecord::Base.sanitize_sql_like(first_name)}%", "%#{ActiveRecord::Base.sanitize_sql_like(last_name)}%")
    else
      result = result.where("LOWER(first_name) LIKE ? OR LOWER(last_name) LIKE ?", "%#{ActiveRecord::Base.sanitize_sql_like(params[:name].downcase)}%", "%#{ActiveRecord::Base.sanitize_sql_like(params[:name].downcase)}%")
    end
    result
  end

  def as_json(args={})
    super(args.merge(
      only: [:id],
      methods: [:name, :show_path, :avatar_url],
    ))
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
