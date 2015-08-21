class SendgridMailer < ActionMailer::Base

	def email(to, subject, body)
        
        mail(:to => to, :from => 'washing@sampleapp.com', :subject => subject) do |format|
            format.text { render :text => body }
            format.html { render :text => body }
        end
    end

end
