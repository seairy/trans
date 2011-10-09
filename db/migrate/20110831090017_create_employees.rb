class CreateEmployees < ActiveRecord::Migration
  def self.up
    create_table :employees do |t|
      t.string :name, :limit => 200, :null => false
      t.integer :role, :limit => 1, :null => false
      t.string :company_name, :title, :phone_number, :email, :limit => 200
      t.string :address, :limit => 1000
      t.string :postal_code, :limit => 20
      t.timestamps
    end
  end

  def self.down
    drop_table :employees
  end
end
