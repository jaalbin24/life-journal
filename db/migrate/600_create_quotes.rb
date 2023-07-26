class CreateQuotes < ActiveRecord::Migration[7.0]
  def change
    create_table :quotes, id: :uuid do |t|
      t.string      :content
      t.string      :author
      t.string      :source
      t.boolean     :deleted
      t.datetime    :deleted_at
      t.timestamps
    end
  end
end
