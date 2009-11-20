class AddChangesAndTestingToCommitAndRevision < ActiveRecord::Migration
  def self.up
    remove_column :commits, :changes_text
    remove_column :commits, :testing_text
    add_column :commits, :changes_text, :text
    add_column :commits, :testing_text, :text
    add_column :releases, :changes_text, :text
    add_column :releases, :testing_text, :text
  end

  def self.down
    remove_column :commits, :changes_text
    remove_column :commits, :testing_text
    remove_column :releases, :changes_text
    remove_column :commits, :changes_text
  end
end
