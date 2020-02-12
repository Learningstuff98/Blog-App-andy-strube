class RemoveDownvoteFromComments < ActiveRecord::Migration[5.2]
  def change
    remove_column :comments, :downvote, :integer
  end
end
