# == Schema Information
#
# Table name: users
#
#  id              :uuid             not null, primary key
#  email           :string
#  password_digest :string
#  status          :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class User < ApplicationRecord
    has_secure_password
    encrypts :email, deterministic: true, downcase: true
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
    has_many :milestones
    has_many :pictures
    has_many :notes, foreign_key: :author_id

end
