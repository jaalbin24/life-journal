class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    enable_extension 'pgcrypto' # Since this is the first migration that will run.
    create_table :users, id: :uuid do |t|

      t.string        :email,                         index: true
      t.string        :password_digest
      t.string        :status
      t.string        :remember_me_token,             index: true, unique: true
      t.datetime      :remember_me_token_expires_at

      t.boolean       :deleted,                       index: true
      t.datetime      :deleted_at,                    index: true

      t.timestamps
    end
  end
end
