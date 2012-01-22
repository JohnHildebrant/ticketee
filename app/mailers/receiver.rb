class Receiver < ActionMailer::Base
  require 'nokogiri'
  require 'logger'
  
  default from: "opsmailer@wizards.com"
  FROM_NAME = "WOTC OPSmailer"
  FROM_ADDRESS = "opsmailer@wizards.com"
  
  def self.parse(email)
    logfile = File.open('/home/ticketeeapp.com/apps/ticketee/current/log/audit.log', 'w')    
    log = Logger.new(logfile)
    if email.multipart?
      body = email.parts[0].body.decoded
    else
      body = email.body.decoded
    end
    body = Nokogiri::HTML(body).text
    body_strip_html_regex = /^<!--.+-->(.+)$/m
    body_match = body_strip_html_regex.match(body)
    body = body_match[1] if body_match
    log.info "Email body = " + body
    message_id = email.to_s["Message-ID"]
    x_mailer = email.header["x-mailer"]
    log.info "email.header = " email.header
    log.info "email.to_s = " + email.to_s
    log.info "message_id = " + message_id
    log.info "x-mailer = " + x_mailer
    logfile.flush
    email.bomb
    # reply_separator = /(.*?)\s?From:\s+WOTC OPSmailer/m
    # comment_match = reply_separator.match(body)
    # if comment_match
    #   comment_text = comment_match[1].strip 
    # else
    #   reply_separator = /(.*?)\s?== ADD YOUR REPLY ABOVE THIS LINE ==/m
    #   comment_match = reply_separator.match(body)
    #   comment_text = comment_match[1].strip if comment_match
    # end
    if comment_text
      log.info "Comment = " + comment_text
      logfile.flush
      to, project_id, ticket_id = email.subject.split("@")[0].split("+")
      if project_id.to_i > 0 && ticket_id.to_i > 0
        project = Project.find(project_id)
        ticket = project.tickets.find(ticket_id)
        user = User.find_by_email(email.from[0].downcase)
        ticket.comments.create(:text => comment_text, :user => user)
      end
    end
  end
end
