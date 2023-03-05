# == Schema Information
#
# Table name: traits
#
#  id          :uuid             not null, primary key
#  description :string
#  score       :integer
#  word        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Trait < ApplicationRecord

    has_many :personality
    has_many :people, through: :personality

end
