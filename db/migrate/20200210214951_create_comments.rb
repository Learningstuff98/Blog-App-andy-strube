class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.text :message
      t.integer :user_id
      t.integer :blog_id
      t.integer :upvote
      t.integer :downvote
      t.timestamps
    end
  end
end
