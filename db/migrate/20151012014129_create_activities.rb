class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string :name
      t.float :distance
      t.integer :venue_id
      t.integer :user_id

      t.timestamps
    end
    add_index :activities, :venue_id
    add_index :activities, :user_id
  end
end
