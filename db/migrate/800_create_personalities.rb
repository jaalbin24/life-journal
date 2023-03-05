class CreatePersonalities < ActiveRecord::Migration[7.0]
  def change
    create_table :personalities, id: :uuid do |t|
      
      t.references :person, null: false, foreign_key: true, type: :uuid
      t.references :trait, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
