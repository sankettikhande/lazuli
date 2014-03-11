class Admin::MessagesController < AdminController	  

  def index     
  end

  def search
    @contact_us = ContactUs.sphinx_search(params, current_user)   
  end  
end
