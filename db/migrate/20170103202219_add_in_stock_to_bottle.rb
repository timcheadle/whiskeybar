class AddInStockToBottle < ActiveRecord::Migration[5.0]
  def change
    add_column :bottles, :in_stock, :boolean
  end
end
