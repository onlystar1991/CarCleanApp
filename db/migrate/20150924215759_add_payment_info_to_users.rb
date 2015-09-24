class AddPaymentInfoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :credit_id, :string

    add_column :users, :credit_exp_month, :string

    add_column :users, :credit_exp_year, :string

    add_column :users, :paypal_email, :string

    add_column :users, :apple_pay_merchant_identify, :string

    add_column :users, :apple_pay_support_network, :string

    add_column :users, :apple_pay_merchant_capabilities, :string

    add_column :users, :apple_pay_country_code, :string

    add_column :users, :apple_pay_currency_code, :string

    add_column :users, :apple_pay_summary_items, :string
    
  end
end
