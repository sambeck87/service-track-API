class CreateMaintenanceServices < ActiveRecord::Migration[6.1]
  def change
    create_table :maintenance_services do |t|
      t.references :car, null: false, foreign_key: true
      t.string :description, null: false
      t.integer :status, null: false, default: 0
      t.date :date

      t.timestamps
    end

    add_index :maintenance_services, :status
  end
end
