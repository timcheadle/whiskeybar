class RemoveFinishedFromBottles < ActiveRecord::Migration[5.0]
  def change
    remove_column :bottles, :finished, :boolean
  end
end
