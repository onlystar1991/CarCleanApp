class AddTypeAndPlateToCars < ActiveRecord::Migration
  def change
    add_column :cars, :type, :string
    add_column :cars, :plate, :string
  end
end
