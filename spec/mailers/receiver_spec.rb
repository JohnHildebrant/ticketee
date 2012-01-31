require "spec_helper"

FROM_NAME = "WOTC OPSmailer"
FROM_ADDRESS = "opsmailer@wizards.com"

describe Receiver do
  
  let(:user) { Factory(:user) }
  
  before do
    @ticket = Factory(:ticket)
    @ticket.watchers << user
  end
  
  it "parses a reply from a comment update into a comment" do
    Delayed::Job.count.should eql(0)
    ticket = @ticket
    ticket.comments.create!(:text => "This is a comment",
                            :user => ticket.user)
    
    Delayed::Job.count.should eql(1)
    
    Delayed::Worker.new.work_off(1)
    Delayed::Job.count.should eql(0)
    
    comment_email = ActionMailer::Base.deliveries.last
    
    mail = 
    Mail.new(:from => user.email, :subject => "Re: #{comment_email.subject}",
             :body => %Q{This is a brand new comment.
               From: #{FROM_NAME} <#{FROM_ADDRESS}>
               #{comment_email.default_part_body}}, 
             :to => comment_email.from)
             
    lambda { Receiver.parse(mail) }.should(change(ticket.comments, :count).by(1))
    
    ticket.comments.last.text.should eql("This is a brand new comment.")
    
  end
end
