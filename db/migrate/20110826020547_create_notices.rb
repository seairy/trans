# -*- encoding : utf-8 -*-
class CreateNotices < ActiveRecord::Migration
  def self.up
    create_table :notices do |t|
      t.references :user, :null => false
      t.string :title, :limit => 200, :null => false
      t.text :content
      t.boolean :read_, :important
      t.timestamps
    end
  end

  def self.down
    drop_table :notices
  end
end

