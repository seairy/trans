# -*- encoding : utf-8 -*-
class CreateExpertises < ActiveRecord::Migration
  def self.up
    create_table :expertises do |t|
      t.references :user, :null => false
      t.references :language, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :expertises
  end
end

