class CarsController < ApplicationController
    
    skip_before_filter :verify_authenticity_token, :only => [:create, :new]
    
    def create
        
        @car = Car.new
        result = @car.setData(params)
        if result == 0
            render json:{
                status: "fail",
                messege: "invalid auth_token"
            }
        else
            if result == 1
                if @car.save
                    render json:{
                        status: "success",
                        messege: "success",
                        car: {
                        }
                    }
                else
                    
                end
            else
                begin
                    if @car.valid?
                        render json:{
                            status: "success",
                            messege: "success",
                            car: {
                                name: @car.car_name,
                                type: @car.type,
                                plate: @car.plate,
                                image_file: @car.car_image_file_name
                            }
                        }
                    else
                        render json:{
                            status: "fail",
                            messege: @car.errors.messages,
                        }
                    end
                rescue Exception => e
                    render json:{
                        status: "fail",
                        messege: "database disconnected"
                    }
                end
            end
        end
    end
end
