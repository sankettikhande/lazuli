class PasswordsController < Devise::PasswordsController

  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    yield resource if block_given?
    respond_to do |format|
      if successfully_sent?(resource)
      	format.js
      	# respond_with({}, :location => after_sending_reset_password_instructions_path_for(resource_name))
	    else
	      format.js
	      # respond_with(resource)
	    end
    end
  end
end  