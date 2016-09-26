class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username, unique: true
      t.string :email, unique: true
      t.string :password_digest
      t.boolean :admin, default: false
      t.boolean :locked, default: false

      t.timestamps null: false
    end
  end
end
