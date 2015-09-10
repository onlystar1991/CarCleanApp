class BrainController < ApplicationController
    
    def client_token
        begin
            render json: {
                client_token: Braintree::ClientToken.generate
            }
        rescue
            render json: {
                client_token: "Authentication Fail"
            }
        end
        
    end
    
    def pay
        nonce = params[:payment_method_nonce]
        if nonce.empty?
            render json:{
                result_code: "pay require payment method"
            }
        else
            result = Braintree::Transaction.sale( amount: params[:amount], payment_method_nonce: nonce)
            if result.success?
                render json: {
                    result_code: "pay successed"
                    }
            else
                render json: {
                    result_code: "pay faild"
                }
            end
        end
    end
    
    
end
