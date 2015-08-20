class UserMailer < ApplicationMailer
    default from: "notification@example.com"
    
    def welcome_email(user)
        @user = user
        
        puts "=============================="
        puts @user.inspect
        
        mail(to: @user.email, subject: "Promotion Code")
    end
    
end
