class RemoveUpvoteFromComments < ActiveRecord::Migration[5.2]
  def change
    remove_column :comments, :upvote, :integer
  end
end
