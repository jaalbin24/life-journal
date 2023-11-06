class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages, id: :uuid do |t|
      t.belongs_to :chat, null: false, foreign_key: true, type: :uuid
      t.belongs_to :user, null: false, foreign_key: true, type: :uuid
      t.string :role
      t.text :content
      t.integer :tokens

      t.timestamps
    end
  end
end
