class AlterSubblogsAddUserId < ActiveRecord::Migration[5.2]
  def change
    add_column :subblogs, :user_id, :integer
    add_index :subblogs, :user_id
  end
end
