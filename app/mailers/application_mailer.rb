class ApplicationMailer < ActionMailer::Base
  default from: "no-reply@freshrocket.com"
  layout 'mailer'
end