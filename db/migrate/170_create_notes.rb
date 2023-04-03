class CreateNotes < ActiveRecord::Migration[7.0]
  def change
    create_table :notes, id: :uuid do |t|
      t.string :content
      t.references :author, null: false, foreign_key: {to_table: :users}, type: :uuid
      t.references :notable, polymorphic: true, null: false, type: :uuid

      t.timestamps
    end
  end
end
