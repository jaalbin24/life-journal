class CreateNotes < ActiveRecord::Migration[7.0]
  def change
    create_table :notes, id: :uuid do |t|
      t.string      :content
      t.references  :user,        null: false, foreign_key: { to_table: :users },   type: :uuid
      t.references  :person,      null: false, foreign_key: { to_table: :people },  type: :uuid
      t.boolean     :deleted,     index: true
      t.datetime    :deleted_at,  index: true
      t.timestamps
    end
  end
end
