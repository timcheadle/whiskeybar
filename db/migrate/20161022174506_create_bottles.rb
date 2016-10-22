class CreateBottles < ActiveRecord::Migration[5.0]
  def change
    create_table :bottles do |t|
      t.string :name
      t.string :producer
      t.string :spirit
      t.integer :volume
      t.decimal :proof
      t.integer :release_year
      t.decimal :price
      t.date :acquired_on
      t.text :notes
      t.string :acquired
      t.boolean :open
      t.boolean :finished
      t.string :location

      t.timestamps
    end
  end
end
