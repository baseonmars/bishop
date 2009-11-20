class AddProcessedCommits < ActiveRecord::Migration
  def self.up
    add_column :commits, :processed, :boolean
  end

  def self.down
    remove_column :commits, :processed
  end
end
