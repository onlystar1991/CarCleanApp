class Car < ActiveRecord::Base
    belongs_to :user
        
    validates :car_image,
        attachment_content_type: { content_type: /\Aimage\/.*\Z/ },
        attachment_size: { less_than: 5.megabytes }

    has_attached_file :car_image
    
    def setData(data)
        
        self.user_id = AESCrypt.decrypt(data['auth_token'], Rails.application.secrets.secret_key_base)
        
        self.car_name = data['car_name']
        
        #self.user_id = data['user_id']
        
        r = Random.new
        rand_initial = r.rand(100000000...300000000)
        
        self.car_image_file_name =  "#{rand_initial}" << data['car_image'].original_filename
        
        directory = "public/data"
        # create the file path
        
        path = File.join(directory, self.car_image_file_name)
        # write the file
        
        File.open(path, "wb") { |f| f.write(data['car_image'].tempfile.read) }
        
        self.car_image_file_size = File.size(data['car_image'].tempfile)
        
        self.car_image_content_type = data['car_image'].content_type

        puts "mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm"
        puts (self.car_image_file_name.inspect)
    end
end
