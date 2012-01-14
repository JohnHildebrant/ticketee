class Admin::IncomingsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  
  def create
    # Being invoked as a POST from the mail_poller
    Receiver.parse(params[:email])
  end                
end