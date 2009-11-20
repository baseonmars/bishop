class CreateReleases < ActiveRecord::Migration
  def self.up
    create_table :releases do |t|
      t.timestamp :updated_at
      t.timestamp :created_at
      t.string :name
      t.text :comments

      t.timestamps
    end
  end

  def self.down
    drop_table :releases
  end
end
