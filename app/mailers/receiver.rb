class Receiver < ActionMailer::Base
  require 'nokogiri'
  require 'logger'
  
  default from: "opsmailer@wizards.com"
  
  def self.parse(email)
    logfile = File.open('/home/ticketeeapp.com/apps/ticketee/current/log/audit.log', 'w')    
    log = Logger.new(logfile)
    body = email.body.decoded
    body = Nokogiri::HTML(body).text
    body_strip_html_regex = /^<!--.+-->(.+)$/m
    body_match = body_strip_html_regex.match(body)
    body = body_match[1] if body_match
    log.info "Email body = " + body
    reply_separator = /(.*?)\s?From:\s+WOTC OPSmailer/m
    comment_match = reply_separator.match(body)
    if comment_match
      comment_text = comment_match[1].strip 
    else
      reply_separator = /(.*?)\s?== ADD YOUR REPLY ABOVE THIS LINE ==/m
      comment_match = reply_separator.match(body)
      comment_text = comment_match[1].strip if comment_match
    end
    if comment_text
      log.info "Comment = " + comment_text
      logfile.flush
      to, project_id, ticket_id = email.subject.split("@")[0].split("+")
      if project_id.to_i > 0 && ticket_id.to_i > 0
        project = Project.find(project_id)
        ticket = project.tickets.find(ticket_id)
        user = User.find_by_email(email.from[0].downcase)
        comment_text.bomb
        ticket.comments.create(:text => comment_text, :user => user)
      end
    end
  end
end
