class AddIndexToEvents < ActiveRecord::Migration
  def self.up
    add_index "events", "user_id"
  end

  def self.down
  end
end
