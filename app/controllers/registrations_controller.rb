class RegistrationsController < Devise::RegistrationsController
require 'rubygems'
require 'twilio-ruby'
  before_action :authenticate_user!



# POST /resource
  def create
    build_resource(sign_up_params)
    
    # TODO move custom code in VerificationController

    # custom code
    resource.generate_pin
    send_pin

    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_flashing_format?
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  def send_pin
    account_sid = "A"
    auth_token = "A"
    client = Twilio::REST::Client.new account_sid, auth_token
    from = "+140844487" # (hidden) Your Twilio number
    pin = resource.pin
    to = sign_up_params[:phone_number]
    name = sign_up_params[:name]
    client.account.messages.create(from: from,to: to,body: "Hello #{name}, your pin is #{pin}")
  end
  # doesnt work for some reason..fix in a later version 
  # TODO make this work
  def twilio_client
    Twilio::REST::Client.new TWILIO_CONFIG['sid'], TWILIO_CONFIG['token']
  end
end
