# -*- encoding : utf-8 -*-
class CreateOperations < ActiveRecord::Migration
  def self.up
    create_table :operations do |t|
      t.references :translation, :null => false
      t.references :user, :null => false
      t.integer :action, :limit => 1, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :operations
  end
end

