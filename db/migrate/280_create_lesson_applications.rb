class CreateLessonApplications < ActiveRecord::Migration[7.0]
  def change
    create_table :lesson_applications, id: :uuid do |t|
      t.references :entry, null: false, foreign_key: true, type: :uuid
      t.references :lesson, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
