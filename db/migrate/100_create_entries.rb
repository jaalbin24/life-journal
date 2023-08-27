class CreateEntries < ActiveRecord::Migration[7.0]
  def change
    create_table :entries, id: :uuid do |t|

      t.datetime    :published_at
      t.boolean     :deleted,                       index: true
      t.datetime    :deleted_at,                    index: true
      t.string      :title
      t.string      :content
      t.string      :content_plain  # A plaintext, non-html version of the content column used in the empty & not_empty scopes
      t.string      :status
      t.references  :user,    foreign_key: {to_table: :users}, type: :uuid

      t.timestamps
    end
  end
end
