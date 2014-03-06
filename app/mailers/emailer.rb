class Emailer < ActionMailer::Base
  default :from => "no-reply@lazuli.com"
  def sent_contact_us(contact_us)  	
    @sent_on = Time.now
    @subject = contact_us.subject
    @contact_us = contact_us    
    mail(:to => admin@lazuli.com , :subject => @subject, :content_type => "text/html")
  end
end

 
