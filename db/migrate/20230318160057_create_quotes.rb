class CreateQuotes < ActiveRecord::Migration[7.0]
  def change
    create_table :quotes, id: :uuid do |t|
      t.string :body
      t.string :author

      t.timestamps
    end
  end
end
