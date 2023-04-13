class CreatePeople < ActiveRecord::Migration[7.0]
  def change
    create_table :people, id: :uuid do |t|

      t.string      :title
      t.string      :first_name
      t.string      :middle_name
      t.string      :last_name
      t.string      :gender
      t.string      :biography

      t.string      :notes
      t.boolean     :deleted
      t.datetime    :deleted_at
      t.references  :created_by,      foreign_key: {to_table: :users}, type: :uuid

      t.timestamps
    end
  end
end
