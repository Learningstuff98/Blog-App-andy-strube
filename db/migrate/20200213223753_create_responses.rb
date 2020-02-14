class CreateResponses < ActiveRecord::Migration[5.2]
  def change
    create_table :responses do |t|
      t.text :response_message
      t.integer :user_id
      t.integer :comment_id
      t.timestamps
    end
    add_index :responses, [:user_id, :comment_id]
    add_index :responses, :comment_id
  end
end
