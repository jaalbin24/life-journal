# == Schema Information
#
# Table name: lessons
#
#  id         :uuid             not null, primary key
#  content    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  person_id  :uuid             not null
#  user_id    :uuid             not null
#
# Indexes
#
#  index_lessons_on_person_id  (person_id)
#  index_lessons_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (person_id => people.id)
#  fk_rails_...  (user_id => users.id)
#
class Lesson < ApplicationRecord
  belongs_to(
    :taught_by,
    class_name: "Person",
    foreign_key: :person_id,
    inverse_of: :lessons
  )
  belongs_to :user, inverse_of: :lessons
  has_many :lesson_applications
  has_many :entries, through: :lesson_applications
end
