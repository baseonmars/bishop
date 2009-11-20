class SwapGoesInForStatusOnCommit < ActiveRecord::Migration
  def self.up
    remove_column :commits, :goes_in
    add_column :commits, :status, :string
  end

  def self.down
    remove_column :commits, :status
    add_column :commits, :goes_in, :boolean
  end
end
