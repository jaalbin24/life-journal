class CreateMilestones < ActiveRecord::Migration[7.0]
  def change
    create_table :milestones, id: :uuid do |t|
      t.string      :content
      t.datetime    :reached_at
      t.references  :entry, null: false, foreign_key: true, type: :uuid
      t.references  :user, null: false, foreign_key: true, type: :uuid
      t.boolean     :deleted
      t.datetime    :deleted_at
      t.timestamps
    end
  end
end
