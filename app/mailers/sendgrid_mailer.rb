class SendgridMailer < ActionMailer::Base

	def email(to, subject, body)
        
        mail(:to => to, :from => "my@sample.com", :subject => subject) do |format|
            format.text { render :text => body }
            format.html { render :text => body }
        end
    end

end
