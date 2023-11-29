class AddLastPersonOfTheDayAtColumnToPeople < ActiveRecord::Migration[7.0]
  def change
    add_column :people, :last_person_of_the_day_at, :datetime
  end
end
