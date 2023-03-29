# == Schema Information
#
# Table name: traits
#
#  id          :uuid             not null, primary key
#  description :string
#  importance  :integer
#  positivity  :integer
#  status      :string
#  word        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Trait < ApplicationRecord

    has_many :personality
    has_many :people, through: :personality

end
