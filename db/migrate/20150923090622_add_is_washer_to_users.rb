class AddIsWasherToUsers < ActiveRecord::Migration
  def change
    add_column :users, :isWasher, :string
  end
end
