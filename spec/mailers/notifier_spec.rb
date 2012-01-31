require 'spec_helper'

describe Notifier do
  
  let(:user) { Factory(:user) }

  before do
    @ticket = Factory(:ticket)
    @ticket.watchers << user
  end
    
  it "correctly sets the subject" do
    
    Delayed::Job.count.should eql(0)
    ticket = @ticket
    comment = ticket.comments.create!(:text => "This is a comment",
                                      :user => ticket.user)
    
    Delayed::Job.count.should eql(1)
    
    Delayed::Worker.new.work_off(1)
    Delayed::Job.count.should eql(0)

    mail = ActionMailer::Base.deliveries.last
    mail.subject.should eql("[opsmailer+#{comment.project.id}+#{comment.ticket.id}@wizards.com] " +
       "#{comment.ticket.project.name} - #{comment.ticket.title}")
  end
  
end