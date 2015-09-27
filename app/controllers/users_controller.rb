class UsersController < ApplicationController
	
    skip_before_filter :verify_authenticity_token, :only => [
                                                            :signup, 
                                                            :signin, 
                                                            :signout, 
                                                            :save_img, 
                                                            :updateLocation, 
                                                            :findWasher,
                                                            :getMyCar,
                                                            :findUser,
                                                            :updatePaymentInfo,
                                                            :updateProfile
                                                        ]
    
    def signin
        
        @user = User.find_by(email: params[:email])

        if @user.nil?
            render json:{
                status: "fail",
                message: "Invaild Email!",
                user: {
                    email: params[:email]
                }
            }
        else
            
            if @user.password == params[:password]
                if @user.logged_in == 1

                    render json:{
                        status: "fail",
                        message: "You have already logged in.",
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
                        }
                    }
                end
            else
                render json:{
                    status: "fail",
                    message: "Pawword is Incorrect.",
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
        
        puts "==========================="
        puts @user.inspect
        puts @user.valid?
        puts @user.errors.messages.inspect

        if !@user.valid?

            if !@user.errors.messages[:email].nil?
                error = "Email " << @user.errors.messages[:email][0].to_s
            else
                if !@user.errors.messages[:password].nil?
                    error = "Password " << @user.errors.messages[:password][0].to_s
                else
                    if !@user.errors.messages[:phonenumber].nil?
                        error = "Phone Number " << @user.errors.messages[:phonenumber][0].to_s
                    else
                        if !@user.errors.messages[:last_name].nil?
                            error = "Last name" << @user.errors.messages[:last_name][0].to_s
                        else
                            if !@user.errors.messages[:first_name].nil?
                                error = "First name" << @user.errors.messages[:first_name][0].to_s
                            else
                                if !@user.errors.messages[:isWasher][0].nil?
                                    error = "Are you washer or driver?"
                                end
                            end
                        end
                    end
                end
            end

            render json:{
                status: "fail",
                message: error,
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
                        email: @user.email,
                        file_name: @user.user_avatar_file_name
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
                message: "Invaild User"
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
    
    def updateProfile
        
        @user = User.find_by(id: params[:user_id])
        @user.updateData(params)

        if !@user.valid?
            
            if !@user.errors.messages[:email].nil?
                error = "Email " << @user.errors.messages[:email][0].to_s
            else
                if !@user.errors.messages[:password].nil?
                    error = "Password " << @user.errors.messages[:password][0].to_s
                else
                    if !@user.errors.messages[:phonenumber].nil?
                        error = "Phone Number " << @user.errors.messages[:phonenumber][0].to_s
                    else
                        if !@user.errors.messages[:last_name].nil?
                            error = "Last name" << @user.errors.messages[:last_name][0].to_s
                        else
                            if !@user.errors.messages[:first_name].nil?
                                error = "First name" << @user.errors.messages[:first_name][0].to_s
                            else
                                if !@user.errors.messages[:isWasher][0].nil?
                                    error = "Are you washer or driver?"
                                end
                            end
                        end
                    end
                end
            end

            render json:{
                status: "fail",
                message: "invalid user",
                error: error
            }
        else
            render json:{
                message: "update success",
                status: "success",
                user: {
                    first_name: @user.first_name,
                    last_name: @user.last_name,
                    phonenumber: @user.phonenumber,
                    email: @user.email,
                    file_name: @user.user_avatar_file_name,
                    user_id: @user.id
                }
            }
        end
    end
    
    def updateLocation
        
        user_id = params[:user_id]
        
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
        
        result_cars = Array.new
        
        @user.cars.each do |car|
            temp = Hash.new
            temp["car_id"] = car.id
            temp["car_name"] = car.car_name
            temp["type"] = car.type
            temp["plate"] = car.plate
            temp["file_name"] = car.car_image_file_name

            result_cars << temp
        end

        if !@user.nil?
            render json: {
                id: params[:user_id],
                email: @user.email,
                message: "success",
                cars: result_cars
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
                status: "success",
                message: "success",
                user: {
                    first_name: @user.first_name,
                    last_name: @user.last_name,
                    phonenumber: @user.phonenumber,
                    email: @user.email,
                    id: @user.id
                }
            }
        else
            render json: {
                status: "fail",
                id: params[:user_id],
                message: "invalid user"
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

                if params[:credit_id].nil? || params[:credit_exp_month] || params[:credit_exp_year]
                    render json: {
                        status: "fail",
                        message: "parameter not set"
                    }
                else
                    @user.update_attribute(:credit_id, params[:credit_id])
                    @user.update_attribute(:credit_exp_month, params[:credit_exp_month])
                    @user.update_attribute(:credit_exp_year, params[:credit_exp_year])
                    
                    render json: {
                        status: "success",
                        message: " "
                    }
                end
            when "Paypal"
                if params[:paypal_email].nil?
                    render json: {
                        status: "fail",
                        message: "parameter not set"
                    }
                else
                    @user.update_attribute(:paypal_email, params[:paypal_email])
                    render json: {
                        status: "success",
                        message: " "
                    }
                end
            when "ApplePay"

                if params[:apple_pay_merchant_identify].nil? || params[:apple_pay_support_network].nil? || params[:apple_pay_merchant_capabilities].nil? || params[:apple_pay_country_code].nil? || params[:apple_pay_currency_code].nil? || params[:apple_pay_summary_items].nil?
                    render json: {
                        status: "fail",
                        message: "parameter not set"
                    }
                else
                    @user.update_attribute(:apple_pay_merchant_identify, params[:apple_pay_merchant_identify])
                    @user.update_attribute(:apple_pay_support_network, params[:apple_pay_support_network])
                    @user.update_attribute(:apple_pay_merchant_capabilities, params[:apple_pay_merchant_capabilities])
                    @user.update_attribute(:apple_pay_country_code, params[:apple_pay_country_code])
                    @user.update_attribute(:apple_pay_currency_code, params[:apple_pay_currency_code])
                    @user.update_attribute(:apple_pay_summary_items, params[:apple_pay_summary_items])
                    render json: {
                        status: "success",
                        message: " ",
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
                        }
                    }
                end
            else
                render json: {
                    status: "fail",
                    message: "parameter not set"
                }
            end
        rescue Exception => e
            render json: {
                status: "fail",
                message: "parameter not set"
            }
        end
    end

end