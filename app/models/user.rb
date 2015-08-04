class User < ActiveRecord::Base
    has_many :cars
    
    EMAIL_REGEX = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i
    validates :first_name , :presence => true
    validates :last_name , :presence => true
    validates :phonenumber , :presence => true
    validates :password, :presence => true, :length => { :in => 5..20 }
    validates :email, :presence => true, :uniqueness => true
	
	def setParams(params)
		self.password = params[:password]
		self.first_name = params[:first_name]
		self.last_name = params[:last_name]
		self.phonenumber = params[:phone_number]
		self.email = params[:email]
        puts "-----------------------"
		puts (self.inspect)
	end
end
