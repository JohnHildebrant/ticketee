class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :ensure_proper_protocol
  before_filter :find_states
  
  protected
  
  def ssl_allowed_action?
    (params[:controller] == 'users/sessions' && ['new', 'create'].
      include?(params[:action])) || (params[:controller] == 'users/registrations' &&
      ['new', 'create', 'edit', 'update'].include?(params[:action])) ||
      (params[:controller] == 'users/omniauth_callbacks')
  end
  
  def ensure_proper_protocol
    if request.ssl? && !ssl_allowed_action?
      redirect_to "http://" + request.host + request.fullpath
    end
  end
  
  def after_sign_in_path_for(resource_or_scope)
    root_url(:protocol => 'http')
  end
  
  def after_sign_out_path_for(resource_or_scope)
    root_url(:protocol => 'http')
  end
  
  private
  
  def authorize_admin!
    authenticate_user! 
    unless current_user.admin?
      flash[:alert] = "You must be an admin to do that."
      redirect_to root_path
    end
  end
  
  def find_states
    @states = State.all
  end
end