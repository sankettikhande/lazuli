class Emailer < ActionMailer::Base
  default :from => Settings.email_settings.default_from_email

  def sent_contact_us(contact_us)  	
    @sent_on = Time.now
    @subject = contact_us.subject
    @contact_us = contact_us    
    mail(:to => Settings.email_settings.contact_us_recipients, :subject => @subject, :content_type => "text/html")
  end

  def share_video(user_share_video)
    @sent_on = Time.now
    @subject = user_share_video.title
    recipient = user_share_video.email
    @user_share_video = user_share_video
    @user = User.find(user_share_video.user_id)
    mail(:to => recipient, :subject => @subject, :content_type => "text/html")	
  end
end

 
