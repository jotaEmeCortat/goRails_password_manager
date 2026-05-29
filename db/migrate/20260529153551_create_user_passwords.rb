class CreateUserPasswords < ActiveRecord::Migration[7.0]
  def change
    create_table :user_passwords do |t|
      t.references :user, null: false, foreign_key: true
      t.references :password, null: false, foreign_key: true

      t.timestamps
    end
  end
end
