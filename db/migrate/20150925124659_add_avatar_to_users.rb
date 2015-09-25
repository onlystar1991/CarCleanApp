class AddAvatarToUsers < ActiveRecord::Migration
  def change
    add_attachment :users, :user_avatar
  end
end
