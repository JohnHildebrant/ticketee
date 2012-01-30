require 'spec_helper'

RSpec.configure do |c|
  # delare an exclusion filter
  c.filter_run_excluding :broken => true
end

describe Notifier do
    
  it "correctly sets the subject", :broken => true do
    comment = Factory(:comment)
    mail = ActionMailer::Base.deliveries.last
    mail.subject.should eql(["opsmailer+#{comment.project.id}+#{comment.ticket.id}@wizards.com] " +
       "#{comment.ticket.project.name} - #{comment.ticket.title}"])
  end
  
end