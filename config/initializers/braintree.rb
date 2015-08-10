#require 'rails_ext/tag_helper_ext'
Braintree::Configuration.environment = :sandbox
Braintree::Configuration.logger = Logger.new('log/braintree.log')
Braintree::Configuration.merchant_id = ENV['BRAINTREE_MERCHANT_ID']
Braintree::Configuration.public_key = ENV['BRAINTREE_PUBLIC_KEY']
Braintree::Configuration.private_key = ENV['BRAINTREE_PRIVATE_KEY']
#BraintreeRails::Configuration.client_side_encryption_key = ENV['CLIENT_SIDE_ENCRYPTION_KEY']
