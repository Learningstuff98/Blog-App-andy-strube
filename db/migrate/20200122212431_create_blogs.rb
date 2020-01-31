class CreateBlogs < ActiveRecord::Migration[5.2]
  def change
    create_table :blogs do |t|
      t.string :title
      t.text :content
      t.integer :user_id
      t.integer :subblog_id
      t.timestamps
    end
    add_index :blogs, [:user_id, :subblog_id]
    add_index :blogs, :subblog_id
  end
end
