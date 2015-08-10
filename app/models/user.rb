class User < ActiveRecord::Base
    has_many :cars
    
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :first_name , :presence => true
    validates :last_name , :presence => true
    validates :phonenumber , :presence => true
    validates :password, :presence => true, :length => { :in => 5..20 }
    validates :email, :presence => true, :uniqueness => true, format: { with: VALID_EMAIL_REGEX }
	
	def setParams(params)
		self.password = params[:password]
		self.first_name = params[:first_name]
		self.last_name = params[:last_name]
		self.phonenumber = params[:phone_number]
		self.email = params[:email]
	end
end
