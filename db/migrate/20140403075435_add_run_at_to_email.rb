class AddRunAtToEmail < ActiveRecord::Migration
  def up
    add_column :emails, :run_at, :datetime
  end

  def down
    remove_column :emails, :run_at
  end
end
