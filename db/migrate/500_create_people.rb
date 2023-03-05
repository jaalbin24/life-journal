class CreatePeople < ActiveRecord::Migration[7.0]
  def change
    create_table :people, id: :uuid do |t|

      t.text          :traits      
      t.string        :first_name
      t.string        :last_name
      t.string        :sex
      t.integer       :age

      t.references    :created_by,      foreign_key: {to_table: :users}, type: :uuid

      t.timestamps
    end
  end
end
