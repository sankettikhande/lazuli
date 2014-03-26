class Admin::MessagesController < AdminController	  

  def index
  	session[:index] = 'checked'
  end

  def search
    @contact_us = ContactUs.sphinx_search(params, current_user)   
  end  
end
