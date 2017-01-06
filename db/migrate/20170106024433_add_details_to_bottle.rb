class AddDetailsToBottle < ActiveRecord::Migration[5.0]
  def change
    add_column :bottles, :details, :string
  end
end
