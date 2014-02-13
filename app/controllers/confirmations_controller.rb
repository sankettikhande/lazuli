class ConfirmationsController < Devise::ConfirmationsController

  def create
    self.resource = resource_class.send_confirmation_instructions(params[resource_name])
    respond_to do |format|
      if successfully_sent?(resource)
      	format.js
      	# respond_with({}, :location => after_resending_confirmation_instructions_path_for(resource_name))
	    else
	      format.js
	      # respond_with(resource)
	    end
    end
  end

end