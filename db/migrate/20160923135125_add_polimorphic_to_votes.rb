class AddPolimorphicToVotes < ActiveRecord::Migration
  def change
    add_column :votes, :votable_type, :string
	rename_column :votes, :post_id, :votable_id
	add_index :votes, [:user_id, :votable_id, :votable_type], unique: true
  end
end
