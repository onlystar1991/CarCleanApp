class User < ActiveRecord::Base
    has_many :cars
    
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :first_name , :presence => true
    validates :last_name , :presence => true
    validates :phonenumber , :presence => true
    validates :password, :presence => true, :length => { :in => 5..20 }
    validates :email, :presence => true, :uniqueness => true, format: { with: VALID_EMAIL_REGEX }
    validates_inclusion_of :isWasher, :in => [true, false]
    

    validates :user_avatar,
        attachment_content_type: { content_type: /\Aimage\/.*\Z/ },
        attachment_size: { less_than: 5.megabytes }

    has_attached_file :user_avatar
	
	def setParams(params)
		self.password = params[:password]
		self.first_name = params[:first_name]
		self.last_name = params[:last_name]
		self.phonenumber = params[:phone_number]
		self.email = params[:email]
        
		self.isWasher = ((params[:isWasher] == 'YES') ? true : false)
        
        puts "----------------------------------"
        puts self.isWasher.inspect
		
        if params['user_avatar'].nil?
			
		else
			puts "----------------------------------"
			puts "avatar setted"
			r = Random.new

            rand_initial = r.rand(100000000...300000000)

            self.user_avatar_file_name =  "#{rand_initial}-" << params['user_avatar'].original_filename

            directory = "public/upload"
            # create the file path

            path = File.join(directory, self.user_avatar_file_name)
            # write the file

            File.open(path, "wb") { |f| f.write(params['user_avatar'].tempfile.read) }

            self.user_avatar_file_size = File.size(params['user_avatar'].tempfile)


            self.user_avatar_content_type = params['user_avatar'].content_type

		end
	end


	def updateData(data)

        begin
            if data['first_name'].nil?
            else 
                self.first_name = data['first_name']
                # self.update_attribute(:plate, data['plate'])
            end


            if data['last_name'].nil?
            else  
                self.last_name = data['last_name']
            end


            if data['phone_number'].nil?
            else  
                self.phonenumber = data['phone_number']
            end


            if data['email'].nil?
            else  
                self.email = data['email']
            end

            if data['user_avatar'].nil?
			
			else

				r = Random.new

	            rand_initial = r.rand(100000000...300000000)

	            self.user_avatar_file_name =  "#{rand_initial}-" << data['user_avatar'].original_filename

	            directory = "public/upload"
	            # create the file path

	            path = File.join(directory, self.user_avatar_file_name)
	            # write the file

	            File.open(path, "wb") { |f| f.write(data['user_avatar'].tempfile.read) }

	            self.user_avatar_file_size = File.size(data['user_avatar'].tempfile)


	            self.user_avatar_content_type = data['user_avatar'].content_type

			end

        rescue NoMethodError => e
            return 1;
        end
    end
end
