# -*- encoding : utf-8 -*-
class CreateAssets < ActiveRecord::Migration
  def self.up
    create_table :assets do |t|
      t.string :original_name, :stored_name, :stored_path, :uri, :content_type, :limit => 200, :null => false
      t.integer :size
      t.timestamps
    end
  end

  def self.down
    drop_table :assets
  end
end

