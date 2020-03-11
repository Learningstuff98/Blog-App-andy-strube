class CreateLocks < ActiveRecord::Migration[5.2]
  def change
    create_table :locks do |t|
      t.boolean :is_locked, default: false
      t.integer :blog_id
      t.timestamps
    end
  end
end
