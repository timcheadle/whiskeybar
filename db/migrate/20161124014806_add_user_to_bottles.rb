class AddUserToBottles < ActiveRecord::Migration[5.0]
  def change
    add_reference :bottles, :user, foreign_key: true
  end
end
