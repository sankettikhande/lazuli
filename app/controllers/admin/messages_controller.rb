class Admin::MessagesController < AdminController	  

  def index
		ContactUs.where(:viewed => false).update_all(viewed: true)
  end

  def search
    @contact_us = ContactUs.sphinx_search(params, current_user)   
  end  
end
