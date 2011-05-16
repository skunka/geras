class AddIndexToEvents < ActiveRecord::Migration
  def self.up
    add_index "events", "user_id"
	drop_table :companies_users
  end

  def self.down
  end
end
