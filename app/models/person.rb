# == Schema Information
#
# Table name: people
#
#  id            :uuid             not null, primary key
#  biography     :string
#  first_name    :string
#  gender        :string
#  last_name     :string
#  middle_name   :string
#  notes         :string
#  status        :string
#  title         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  created_by_id :uuid
#
# Indexes
#
#  index_people_on_created_by_id  (created_by_id)
#
# Foreign Keys
#
#  fk_rails_...  (created_by_id => users.id)
#
class Person < ApplicationRecord

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
        :created_by,
        class_name: "User",
        foreign_key: :created_by_id,
        inverse_of: :people
    )
    validates :name, presence: true


    def name
        [first_name, middle_name, last_name].reject(&:blank?).join(" ")
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
