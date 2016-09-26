class ChangeCommentableToComments < ActiveRecord::Migration
  def change
    rename_column :comments, :commetable_id, :commentable_id
  end
end
