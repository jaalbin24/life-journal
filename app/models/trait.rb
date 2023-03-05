class Trait < ApplicationRecord

    has_many :personality
    has_many :people, through: :personality

end
