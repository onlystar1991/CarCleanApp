class AddAttachmentCarImageToCars < ActiveRecord::Migration
  def self.up
      add_attachment :cars, :car_image
  end

  def self.down
      remove_attachment :cars, :car_image
  end
end
