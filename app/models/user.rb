# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  email           :string
#  password_digest :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  public_id       :string
#
class User < ApplicationRecord
    has_secure_password
    include PubliclyIdentifiable

    has_many(
        :entries,
        class_name: "Entry",
        foreign_key: :author_id,
        inverse_of: :author,
        dependent: :destroy
    )

end
