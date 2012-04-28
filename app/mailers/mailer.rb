class Mailer < ActionMailer::Base
  default from: "kzdh@hanban.org"
  
  def notification address, name, title, content
    @name = name
    @content = content
    mail(:to => address, :subject => title)
  end
end
