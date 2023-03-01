class CreateEntries < ActiveRecord::Migration[7.0]
  def change
    create_table :entries do |t|
      t.datetime    :published_at
      t.string      :title
      t.string      :text_content

      t.references  :author,    foreign_key: {to_table: :users}
      t.boolean     :draft?

      t.timestamps
    end
  end
end
