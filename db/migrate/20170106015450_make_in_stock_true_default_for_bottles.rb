class MakeInStockTrueDefaultForBottles < ActiveRecord::Migration[5.0]
  def change
    change_column :bottles, :in_stock, :boolean, default: true
  end
end
