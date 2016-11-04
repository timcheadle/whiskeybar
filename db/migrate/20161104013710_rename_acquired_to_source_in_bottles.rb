class RenameAcquiredToSourceInBottles < ActiveRecord::Migration[5.0]
  def change
    rename_column :bottles, :acquired, :source
  end
end
