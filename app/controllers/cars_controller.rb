class CarsController < ApplicationController
    
    skip_before_filter :verify_authenticity_token, :only => [:create, :new]
    
    def new
        
    end
    
    def create
        
        puts ("-----------------------------")
        puts params.inspect
        
        @car = Car.new
        @car.setData(params)
        
        
        puts ("+++++++++++++++++++++++++++++++++++")
        puts @car.inspect
        
        begin
            if @car.valid?    
                if @car.save
                    render json:{
                        result_code: "car save success"    
                    }
                else
                    render json:{
                        result_code: "invalid file format or file size too large"
                    }
                end
            else
                render json:{
                        result_code: "invalid file format or file size too large"
                }
            end
        rescue ActiveRecord::CatchAll
            render json:{
                result_code: "invalid auth_token"
            }
        end
    end
    
end
