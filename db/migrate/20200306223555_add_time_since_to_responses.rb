class AddTimeSinceToResponses < ActiveRecord::Migration[5.2]
  def change
    add_column :responses, :time_since, :string
  end
end
