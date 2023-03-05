class CreateTraits < ActiveRecord::Migration[7.0]
  def change
    create_table :traits, id: :uuid do |t|
      t.string      :word
      t.integer     :score
      t.string      :description

      t.timestamps
    end
  end
end
