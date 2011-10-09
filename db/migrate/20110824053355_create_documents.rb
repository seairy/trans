# -*- encoding : utf-8 -*-
class CreateDocuments < ActiveRecord::Migration
  def self.up
    create_table :documents do |t|
      t.references :category
      t.references :uploader
      t.references :file
      t.string :title, :limit => 200, :null => false
      t.integer :word_count, :state
      t.integer :priority, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :documents
  end
end

