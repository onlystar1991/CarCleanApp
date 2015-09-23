class AddLocationDataToUsers < ActiveRecord::Migration
  def change
    add_column :users, :loc_latitude, :string
    add_column :users, :loc_longitude, :string
  end
end
