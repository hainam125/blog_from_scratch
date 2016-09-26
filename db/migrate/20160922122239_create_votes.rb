class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :value, default: 0
      t.references :user, index: true, foreign_key: true
      t.references :post, index: true

      t.timestamps null: false
    end
  end
end
