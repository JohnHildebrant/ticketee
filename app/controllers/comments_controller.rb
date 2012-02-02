require 'htmlentities'

class CommentsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :authenticate_user!
  before_filter :find_ticket

  cache_sweeper :comments_sweeper, :only => [:create]
  
  def create
    if !current_user.admin? && cannot?(:"change states", @ticket.project)
      params[:comment].delete(:state_id)
    end
    @comment = @ticket.comments.build(params[:comment].merge(:user => current_user))
    if @comment.save
      if can?(:tag, @ticket.project) || current_user.admin?
        @ticket.tag!(params[:tags])
      end
      flash[:notice] = "Comment has been created."
      redirect_to [@ticket.project, @ticket]
    else
      @states = State.all
      flash[:alert] = "Comment has not been created."
      render :template => "tickets/show"
    end
  end
    
  private
    def find_ticket
      @ticket = Ticket.find(params[:ticket_id])
    end
end
