class User < ActiveRecord::Base

	#attr_accessor :password, :first_name, :last_name, :phone_number, :email
  EMAIL_REGEX = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i
  validates :first_name, :presence => true, :length => { :in => 1..20 }
	validates :last_name, :presence => true, :length => { :in => 1..20 }
  validates :phone_number, :presence => true, :length => { :in => 1..20 }
  validates :password, :presence => true, :length => { :in => 3..20 }
	validates :email, :presence => true, :uniqueness => true
	
	def setParams(params)
		self.password = params[:password]
		self.first_name = params[:first_name]
		self.last_name = params[:last_name]
		self.phone_number = params[:phone_number]
		self.email = params[:email]
	end
end
