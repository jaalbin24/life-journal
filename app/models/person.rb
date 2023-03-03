# == Schema Information
#
# Table name: people
#
#  id            :bigint           not null, primary key
#  age           :integer
#  first_name    :string
#  last_name     :string
#  sex           :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  created_by_id :bigint
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
    include PubliclyIdentifiable

    has_many(
        :mentions,
        class_name: "Mention",
        foreign_key: :person_id,
        inverse_of: :person,
        dependent: :destroy
    )

    belongs_to(
        :created_by,
        class_name: "User",
        foreign_key: :created_by_id,
        inverse_of: :people
    )

    def name
        [first_name, last_name].reject(&:blank?).join(" ")
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
            only: [:public_id],
            methods: [:name, :show_path, :avatar_url],
        ))
    end

    def show_path
        Rails.application.routes.url_helpers.person_path(self)
    end

    def avatar_url
        Rails.application.routes.url_helpers.url_for(self.avatar)
    end
end
