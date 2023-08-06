# == Schema Information
#
# Table name: personalities
#
#  id         :uuid             not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  person_id  :uuid             not null
#  trait_id   :uuid             not null
#
# Indexes
#
#  index_personalities_on_person_id  (person_id)
#  index_personalities_on_trait_id   (trait_id)
#
# Foreign Keys
#
#  fk_rails_...  (person_id => people.id)
#  fk_rails_...  (trait_id => traits.id)
#
FactoryBot.define do
  factory :personality do
    
  end
end
