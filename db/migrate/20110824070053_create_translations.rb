# -*- encoding : utf-8 -*-
class CreateTranslations < ActiveRecord::Migration
  def self.up
    create_table :translations do |t|
      t.references :document, :null => false
      t.references :language, :null => false
      t.references :owner
      t.references :assignee
      t.references :file
      t.references :linguister
      t.references :embellisher
      t.references :reader
      t.references :editor
      t.integer :state
      t.timestamps
    end
  end

  def self.down
    drop_table :translations
  end
end

