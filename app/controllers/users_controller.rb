class UsersController < ApplicationController
	
	skip_before_filter :verify_authenticity_token, :only => [:signup, :signin, :signout]

    def signin

        @user = User.find_by(email: params[:email])
        if @user.nil?
            render json:{
                result_code: "email invalid"
            }
        else
            if @user.password == params[:password]
                if @user.logged_in == 1 
                    render json:{
                        result_code: "already logged in"    
                    }
                else
                    @user.update_attribute(:logged_in, 1)

                    render json:{
                        result_code: "login success"
                    }
                end
            else
                render json:{
                    result_code: "password incorrect"
                }
            end
        end
    end

    
    def signup		
        @user = User.new

        @user.setParams(params)
        
        puts "---------------------------------"
        puts @user.inspect
        if !@user.valid?
            render json:{
                result_code: "email format invalid or password length is not enough"
            }
        else
            if @user.save
                render json:{
                    result_code: "sign up success"
                }
            else
                render json:{
                    result_code: " email already exists"
                }
            end
        end
    end
    
    def signout
        @user = User.find_by(email: params[:email])
        if @user.nil?
            render json:{
                result_code: "email invalid"
            }
        else
            if @user.update_attribute(:logged_in, 0)
                render json:{
                    result_code: "successfully logged out"
                }
            else
                render json:{
                    result_code: "logged out fail"
                }
        end
    end

end
