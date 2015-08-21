class CarsController < ApplicationController
    
    skip_before_filter :verify_authenticity_token, :only => [:create, :new]
    
    def new
        
    end
    
    def create
        
        @car = Car.new
        result = @car.setData(params)
        if result == 0
            render json:{
                status: "fail",
                messege: "invalid auth_token"
            }
        else
            
            begin
                if @car.valid?
                    if @car.save
                        render json:{
                            status: "success",
                            messege: "success",
                            car: {
                                name: @car.name,
                                image_file: @car.car_image_file_name
                            }
                        }
                    else
                        render json:{
                            status: "fail",
                            messege: "invalid file format or file size too large",
                            car: {
                                name: params['car_name']
                            }
                        }
                    end
                else
                    render json:{
                        status: "fail",
                        messege: @car.errors.messages,
                    }
                end
            rescue ActiveRecord::CatchAll
                render json:{
                    status: "fail",
                    messege: "invalid auth_token"
                }
            end
        end
    end
end
