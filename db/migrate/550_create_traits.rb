class CreateTraits < ActiveRecord::Migration[7.0]
  def change
    create_table :traits, id: :uuid do |t|
      t.string      :word
      t.integer     :positivity # -100 - 100
      t.integer     :importance # 0 - 100
      t.string      :status
      t.string      :description

      t.timestamps
    end
  end
end
