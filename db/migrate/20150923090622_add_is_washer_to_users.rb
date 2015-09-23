class AddIsWasherToUsers < ActiveRecord::Migration
  def change
    add_column :users, :isWasher, :boolean
  end
end
