class ConfirmationsController < Devise::ConfirmationsController

  def create
    self.resource = resource_class.send_confirmation_instructions(params[resource_name])
    successfully_sent?(resource)
  end

end