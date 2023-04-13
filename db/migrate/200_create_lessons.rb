class CreateLessons < ActiveRecord::Migration[7.0]
  def change
    create_table :lessons, id: :uuid do |t|
      t.references  :person,                foreign_key: true, type: :uuid
      t.references  :user,    null: false,  foreign_key: true, type: :uuid
      t.string      :status
      t.string      :content
      t.boolean     :deleted
      t.datetime    :deleted_at
      t.timestamps
    end
  end
end
