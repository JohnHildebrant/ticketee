class Api::V1::ProjectsController < Api::V1::BaseController
  before_filter :authorize_admin!, :except => [:index, :show]
  before_filter :find_project, :only => [:show, :update, :destroy]
  
  def index
    respond_with(Project.for(current_user))
  end
end