class CreateMentions < ActiveRecord::Migration[7.0]
  def change
    create_table :mentions, id: :uuid do |t|
      t.references    :person,    foreign_key: {to_table: :people}, type: :uuid
      t.references    :entry,     foreign_key: {to_table: :entries}, type: :uuid
      t.timestamps
    end
  end
end
