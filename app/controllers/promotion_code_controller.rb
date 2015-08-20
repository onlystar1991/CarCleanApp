class PromotionCodeController < ApplicationController
    skip_before_filter :verify_authenticity_token, :only => [:create, :new]
    
    def new
        
    end
    
    def create
        @promo_code = PromotionCode.new
        
        @promo_code.email = params[:email]
        @promo_code.code = params[:promo_code]
        
        if @promo_code.valid?
            @promo_code.save
            puts ">>>>>>>>>>>>>>>>>>>>>>>>>"
            puts @promo_code.inspect
            
            UserMailer.welcome_email(@promo_code).deliver_later
            render json:{
                    status: "success",
                    message: "email sent",
                }
        else
            render json:{
                    status: "promotion_code error",
                    message: @promo_code.errors.messages,
                }
        end
    end
end
