class PromotionCodeController < ApplicationController
    skip_before_filter :verify_authenticity_token, :only => [:create, :new]
    
    def new
        
    end
    
    def create
        @promo_code = PromotionCode.new
        
        @promo_code.email = params[:email]
        @promo_code.code = params[:promo_code]

        
        if @promo_code.valid?
            
            to = params[:email]
            subject = "Promotion Code"
            body = params[:promo_code]
            begin
                response = SendgridMailer.email(to, subject, body).deliver
                
                render json:{
                    status: "success",
                    message: "email sent",
                }
            rescue Exception => e
                render json:{
                    status: "fail",
                    message: e.inspect
                }
            end
        else
            render json:{
                    status: "promotion_code error",
                    message: @promo_code.errors.messages,
                }
        end
    end
end
