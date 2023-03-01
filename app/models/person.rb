# == Schema Information
#
# Table name: people
#
#  id         :bigint           not null, primary key
#  age        :integer
#  first_name :string
#  last_name  :string
#  sex        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Person < ApplicationRecord

    has_many(
        :mentions,
        class_name: "Mention",
        foreign_key: :person_id,
        inverse_of: :person,
        dependent: :destroy
    )

    def name
        [first_name, last_name].reject(&:blank?).join(" ")
    end
end
