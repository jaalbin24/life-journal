class CreatePeople < ActiveRecord::Migration[7.0]
  def change
    create_table :people, id: :uuid do |t|

      t.string      :title
      t.string      :first_name
      t.string      :middle_name
      t.string      :last_name
      t.string      :nickname
      t.string      :gender
      t.string      :biography

      t.string      :notes
      t.boolean     :deleted,                       index: true
      t.datetime    :deleted_at,                    index: true
      t.references  :user,      foreign_key: {to_table: :users}, type: :uuid

      t.timestamps
    end
  end
end
