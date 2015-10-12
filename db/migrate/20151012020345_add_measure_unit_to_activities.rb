class AddMeasureUnitToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :measure_unit, :string
    add_index :activities, :measure_unit
  end
end
