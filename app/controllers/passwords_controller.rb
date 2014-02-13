class PasswordsController < Devise::PasswordsController

  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    yield resource if block_given?
    successfully_sent?(resource)
  end
end  