class CreateCars < ActiveRecord::Migration[6.1]
  def change
    create_table :cars do |t|
      t.string :plate_number
      t.string :model
      t.integer :year

      t.timestamps
    end

    add_index :cars, :plate_number, unique: true
  end
end
