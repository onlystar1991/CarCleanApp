class CreatePromotionCodes < ActiveRecord::Migration
  def change
    create_table :promotion_codes do |t|
      t.string :email
      t.integer :code

      t.timestamps null: false
    end
  end
end
