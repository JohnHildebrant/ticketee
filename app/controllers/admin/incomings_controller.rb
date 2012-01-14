class Admin::IncomingsController < ApplicationController
  require 'mail'
  skip_before_filter :verify_authenticity_token
  
  def create
    # Being invoked as a POST from the mail_poller
    message = Mail.new(params[:email])
    Receiver.parse(message)
  end                
end