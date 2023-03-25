class CreateEntries < ActiveRecord::Migration[7.0]
  def change
    create_table :entries, id: :uuid do |t|

      t.datetime    :published_at
      t.datetime    :deleted_at
      t.string      :title
      t.string      :text_content
      t.string      :status
      t.references  :author,    foreign_key: {to_table: :users}, type: :uuid

      t.timestamps
    end
  end
end
