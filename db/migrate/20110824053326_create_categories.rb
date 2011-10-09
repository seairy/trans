# -*- encoding : utf-8 -*-
class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.integer :parent_id, :lft, :rgt
      t.string :name, :limit => 50, :null => false
      t.integer :position, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :categories
  end
end

