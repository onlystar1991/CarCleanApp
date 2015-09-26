class Car < ActiveRecord::Base
    belongs_to :user
    
    validates :car_name , :presence => true
    
    validates :car_image,
        attachment_content_type: { content_type: /\Aimage\/.*\Z/ },
        attachment_size: { less_than: 5.megabytes }

    has_attached_file :car_image
    
    def setData(data)
        
        begin
            self.user_id = data['user_id']
            
            self.car_name = data['car_name']
            self.plate = data['plate']
            self.type = data['type']
            r = Random.new

            rand_initial = r.rand(100000000...300000000)

            self.car_image_file_name =  "#{rand_initial}-" << data['car_image'].original_filename

            directory = "public/data"
            # create the file path

            path = File.join(directory, self.car_image_file_name)
            # write the file

            File.open(path, "wb") { |f| f.write(data['car_image'].tempfile.read) }

            self.car_image_file_size = File.size(data['car_image'].tempfile)


            self.car_image_content_type = data['car_image'].content_type

        rescue NoMethodError => e

            return 1;
        rescue Exception => e
            
            return 0;
        end
    end

    def updateData(data)

        begin
            if data['plate'].nil?
            else 
                self.plate = data['plate']
                # self.update_attribute(:plate, data['plate'])
            end

            if data['type'].nil?
            else  
                self.type = data['type']
            end

            r = Random.new

            rand_initial = r.rand(100000000...300000000)

            self.car_image_file_name =  "#{rand_initial}-" << data['car_image'].original_filename

            directory = "public/data"
            # create the file path

            path = File.join(directory, self.car_image_file_name)
            # write the file

            File.open(path, "wb") { |f| f.write(data['car_image'].tempfile.read) }

            self.car_image_file_size = File.size(data['car_image'].tempfile)


            self.car_image_content_type = data['car_image'].content_type

        rescue NoMethodError => e
            return 1;
        end
    end

end
