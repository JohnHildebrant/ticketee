class Receiver < ActionMailer::Base
  require 'nokogiri'
  require 'logger'

  default from: "opsmailer@wizards.com"
  FROM_NAME = "WOTC OPSmailer"
  FROM_ADDRESS = "opsmailer@wizards.com"

  def self.parse(email)
    logfile = File.open("#{Rails.root}/log/audit.log", 'w')
    log = Logger.new(logfile)
    if email.multipart?
      body = email.parts[0].body.decoded
    else
      body = email.body.decoded
    end
    log.info "Original body = " + body
    body = Nokogiri::HTML(body).text
    body_strip_html_regex = /^<!--.+-->(.+)$/m
    body_match = body_strip_html_regex.match(body)
    body = body_match[1] if body_match
    log.info "Email body = " + body
    message_id = email.header['Message-ID'].to_s
    log.info "Message-ID = " + message_id
    log.info email.header
    logfile.flush
    # Outlook
    reply_separator = /^(.*?)\s?From:\s+#{FROM_NAME}.*$/m
    comment_match = reply_separator.match(body)
    if comment_match
      comment_text = comment_match[1].strip
    else
      # Gmail
      reply_separator = /^(.*?)\s?On.*#{FROM_NAME}\s+<#{FROM_ADDRESS}>\s*wrote:.*$/m
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
        ticket.comments.create(:text => comment_text, :user => user)
        ticket.invalidate_cache
      end
    end
  end
end