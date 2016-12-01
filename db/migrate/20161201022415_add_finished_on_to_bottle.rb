class AddFinishedOnToBottle < ActiveRecord::Migration[5.0]
  def change
    add_column :bottles, :finished_on, :date
  end
end
