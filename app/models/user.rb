# == Schema Information
#
# Table name: users
#
#  id              :uuid             not null, primary key
#  email           :string
#  password_digest :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class User < ApplicationRecord
    has_secure_password
    has_many(
        :entries,
        class_name: "Entry",
        foreign_key: :author_id,
        inverse_of: :author,
        dependent: :destroy
    )

    has_many(
        :people,
        class_name: "Person",
        foreign_key: :created_by_id,
        inverse_of: :created_by,
        dependent: :destroy
    )
    has_many :lessons

end
