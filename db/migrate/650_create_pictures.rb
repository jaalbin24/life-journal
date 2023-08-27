class CreatePictures < ActiveRecord::Migration[7.0]
  def change
    create_table :pictures, id: :uuid do |t|
      t.string      :description
      t.string      :title
      t.references  :entry, null: false, foreign_key: true, type: :uuid
      t.references  :user, null: false, foreign_key: true, type: :uuid
      t.boolean     :deleted,                       index: true
      t.datetime    :deleted_at,                    index: true
      t.timestamps
    end
  end
end
