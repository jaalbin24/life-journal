class CreateMentions < ActiveRecord::Migration[7.0]
  def change
    create_table :mentions do |t|
      t.references    :person,    foreign_key: {to_table: :people}
      t.references    :entry,     foreign_key: {to_table: :entries}
      t.timestamps
    end
  end
end
