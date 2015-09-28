class AddCvcToUsers < ActiveRecord::Migration
  def change
    add_column :users, :credit_cvc, :string
  end
end
