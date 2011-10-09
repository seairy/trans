# -*- encoding : utf-8 -*-
class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.references :translation, :null => false
      t.references :user, :null => false
      t.text :content
      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end

