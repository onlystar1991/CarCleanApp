class UsersController < ApplicationController
	
	skip_before_filter :verify_authenticity_token, :only => [:signup, :signin]

  def signin

		@user = User.find(:all, :conditions => { :password=>params[:password] } )
		if @user.nil?
			render json:{
				result_code: "email invalid"
			}
		else
			if @user.getPassword == params[:password]
				render json:{
					result_code: "login success"
				}
			else
				render json:{
					result_code: "login faild"
				}
			end
		end
  end

  def signup		
		@user = User.new
		@user.setParams(params)
		
		puts(@user.inspect)
		if @user.save
			render json:{
				result_code: "sign up success"
			}
		else
			render json:{
				result_code: "sign up faild"
			}
		end
  end

end
