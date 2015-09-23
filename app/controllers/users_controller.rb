class UsersController < ApplicationController
	
    skip_before_filter :verify_authenticity_token, :only => [
                                                            :signup, 
                                                            :signin, 
                                                            :signout, 
                                                            :save_img, 
                                                            :updateLocation, 
                                                            :findWasher,
                                                            :getMyCar
                                                        ]
    
    def signin
        @user = User.find_by(email: params[:email])
        if @user.nil?
            render json:{
                status: "fail",
                message: "email doesnot exist",
                user: {
                    email: params[:email]
                }
            }
        else

            @user.update_attribute(:logged_in, 0)

            if @user.password == params[:password]
                if @user.logged_in == 1

                    render json:{
                        status: "fail",
                        message: "already logged in",
                        user: {
                            email: params[:email]
                        }
                    }
                else
                    @user.update_attribute(:logged_in, 1)
                    
                    crypt = generate_auth_token

                    auth_token = crypt.encrypt_and_sign(@user.id)
                    
                    render json:{
                        status: "success",
                        message: "success",
                        user: {
                            first_name: @user.first_name,
                            last_name: @user.last_name,
                            phonenumber: @user.phonenumber,
                            email: @user.email,
                            auth_token: auth_token
                        }
                    }
                end
            else
                render json:{
                    status: "fail",
                    message: "password incorrect",
                    user: {
                        email: params[:email]
                    }
                }
            end
        end
    end

    
    
    def signup
        @user = User.new
        @user.setParams(params)
        
        if !@user.valid?
            
            puts(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
            puts(@user.errors.messages)
            
            render json:{
                status: "fail",
                message: @user.errors.messages,
                user: {
                    first_name: params[:first_name],
                    last_name: params[:last_name],
                    phonenumber: params[:phonenumber],
                    email: params[:email]
                }
            }
        else
            if @user.save
                render json:{
                    message: "sign up success",
                    status: "success",
                    user: {
                        first_name: @user.first_name,
                        last_name: @user.last_name,
                        phonenumber: @user.phonenumber,
                        email: @user.email
                    }
                }
            else
                render json:{
                    message: "database error, try again later",
                    status: "fail",
                    user: {
                        first_name: @user.first_name,
                        last_name: @user.last_name,
                        phonenumber: @user.phonenumber,
                        email: @user.email
                    }
                }
            end
        end
    end

    
    
    def signout
        @user = User.find_by(email: params[:email])
        if @user.nil?
            render json:{
                status: "fail",
                message: "invalid email"
            }
        else
            if @user.update_attribute(:logged_in, 0)
                render json:{
                    status: "success",
                    message: "success",
                    user: {
                        first_name: @user.first_name,
                        last_name: @user.last_name,
                        phonenumber: @user.phonenumber,
                        email: @user.email
                    }
                }
            else
                render json:{
                    status: "fail",
                    message: "database error"
                }
            end
        end
    end
    
    
    def updateLocation
        crypt = generate_auth_token
        
        user_id = crypt.decrypt_and_verify(params[:auth_token])
        
        @user = User.find_by(id: user_id)
        @user.update_attribute(:loc_latitude, params[:latitude])
        @user.update_attribute(:loc_longitude, params[:longitude])
        
        render json: {
            auth_token: params[:auth_token],
            status: "success",
            user: {
                email: "",
                phonenumber: "",
                loc_latitude: "",
                loc_longitude: ""
            }
        }
    end

    def findWasher
        @washers = User.find(isWasher: true)
        render json: {
            washers: @washers
        }
    end

    def getMyCar
        crypt = generate_auth_token
        begin
            user_id = crypt.decrypt_and_verify(params[:auth_token])
            @user = User.find_by(id: user_id)
            render json: {
                auth_token: params[:auth_token],
                message: "success",
                cars: @user.cars
            }

        rescue Exception => e
            render json: {
                auth_token: params[:auth_token],
                message: "invalid token"
            }
        end
    end

    private
    
    def generate_auth_token
        crypt = ActiveSupport::MessageEncryptor.new(Rails.application.secrets.secret_key_base)
    end
end