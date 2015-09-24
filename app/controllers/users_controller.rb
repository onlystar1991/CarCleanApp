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
            
            # This should be deleted

            @user.update_attribute(:logged_in, 0)
            
            # This should be deleted
            
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
                    
                    render json:{
                        status: "success",
                        message: "success",
                        user: {
                            first_name: @user.first_name,
                            last_name: @user.last_name,
                            phonenumber: @user.phonenumber,
                            email: @user.email,
                            id: @user.id,
                            credit_id: @user.credit_id,
                            credit_card_exp_month: @user.credit_exp_month,
                            credit_card_exp_year: @user.credit_exp_year,
                            paypal_email: @user.paypal_email,
                            apple_pay_merchant_identify: @user.apple_pay_merchant_identify,
                            apple_pay_support_network: @user.apple_pay_support_network,
                            apple_pay_merchant_capabilities: @user.apple_pay_merchant_capabilities,
                            apple_pay_country_code: @user.apple_pay_country_code,
                            apple_pay_currency_code: @user.apple_pay_currency_code,
                            apple_pay_summary_items: @user.apple_pay_summary_items,
                            cars: @user.cars
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
        @user = User.find_by(id: params[:user_id])
        if @user.nil?
            render json:{
                status: "fail",
                message: "invalid user"
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
                        email: @user.email,
                        user_id: @user.id
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
        
        user_id = params[:id]
        
        @user = User.find_by(id: user_id)
        @user.update_attribute(:loc_latitude, params[:latitude])
        @user.update_attribute(:loc_longitude, params[:longitude])
        
        render json: {
            status: "success",
            user: {
                id: @user.id,
                email: @user.email,
                phonenumber: @user.phonenumber,
                loc_latitude: @user.loc_latitude,
                loc_longitude: @user.loc_longitude
            }
        }
    end

    def findWasher
        @washers = User.find(isWasher: true)
        #@washers = User.all
        results = Array.new
        @washers.each do |washer|
            temp = Hash.new
            temp["id"] = washer.id
            temp["email"] = washer.email
            temp["phonenumber"] = washer.phonenumber
            temp["loc_longitude"] = washer.loc_longitude
            temp["loc_latitude"] = washer.loc_latitude
            results << temp
        end

        render json: {
            washers: results
        }
    end

    def getMyCar
        user_id = params[:user_id]
        @user = User.find_by(id: user_id)
        if !@user.nil?
            render json: {
                id: params[:user_id],
                message: "success",
                cars: @user.cars
            }
        else
            render json: {
                id: params[:user_id],
                message: "invalid user",
            }
        end

    end

    def findUser
        user_id = params[:user_id]
        @user = User.find_by(id: user_id)
        if !@user.nil?
            render json: {
                message: "success",
                user: {
                    first_name: @user.first_name,
                    last_name: @user.last_name,
                    phonenumber: @user.phonenumber,
                    email: @user.email,
                    id: @user.id,
                    cars: @user.cars
                }
            }
        else
            render json: {
                id: params[:user_id],
                message: "invalid user",
            }
        end        
    end

    def updatePaymentInfo

        user_id = params[:user_id]
        @user = User.find_by(id: user_id)
        paymentType = params[:paymentType]

        begin
            case paymentType
            when "CreditCard"
                @user.update_attribute(:credit_id, params[:credit_id])
                @user.update_attribute(:credit_exp_month, params[:credit_exp_month])
                @user.update_attribute(:credit_exp_year, params[:credit_exp_year])
            when "Paypal"
                @user.update_attribute(:paypal_email, params[:paypal_email])
            when "ApplePay"
                @user.update_attribute(:apple_pay_merchant_identify, params[:apple_pay_merchant_identify])
                @user.update_attribute(:apple_pay_support_network, params[:apple_pay_support_network])
                @user.update_attribute(:apple_pay_merchant_capabilities, params[:apple_pay_merchant_capabilities])
                @user.update_attribute(:apple_pay_country_code, params[:apple_pay_country_code])
                @user.update_attribute(:apple_pay_currency_code, params[:apple_pay_currency_code])
                @user.update_attribute(:apple_pay_summary_items, params[:apple_pay_summary_items])
            end
            render json: {
                status: "success"
            }
        rescue Exception => e
            render json: {
                status: "fail"
            }
        end
    end

    private
    
    def generate_auth_token
        crypt = ActiveSupport::MessageEncryptor.new(Rails.application.secrets.secret_key_base)
    end
end