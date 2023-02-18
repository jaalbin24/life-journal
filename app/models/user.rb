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


end
