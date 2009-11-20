class CreateCommits < ActiveRecord::Migration
  def self.up
    create_table :commits do |t|
      t.integer :revision
      t.string :user
      t.datetime :date
      t.text :files
      t.text :comments
      t.boolean :goes_in
      t.integer :release_id

      t.timestamps
    end
  end

  def self.down
    drop_table :commits
  end
end
