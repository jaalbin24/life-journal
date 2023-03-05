class Personality < ApplicationRecord
  belongs_to :person
  belongs_to :trait
end
