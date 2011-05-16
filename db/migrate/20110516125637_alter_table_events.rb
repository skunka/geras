class AlterTableEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :company_id, :integer
	add_column :events, :starttime, :datetime
	add_column :events, :endtime, :datetime
	add_column :events, :all_day, :boolean, :default => false
  end

  def self.down
  end
end
