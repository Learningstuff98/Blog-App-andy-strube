class AddUserNameToResponses < ActiveRecord::Migration[5.2]
  def change
    add_column :responses, :username, :string
  end
end
