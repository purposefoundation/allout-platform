class AddRunAtToBlast < ActiveRecord::Migration
  def up
    add_column :blasts, :run_at, :datetime
  end

  def down
    remove_column :blasts, :run_at
  end
end
