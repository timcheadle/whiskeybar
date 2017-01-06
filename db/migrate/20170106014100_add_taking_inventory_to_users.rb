class AddTakingInventoryToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :taking_inventory, :boolean, default: false
  end
end
