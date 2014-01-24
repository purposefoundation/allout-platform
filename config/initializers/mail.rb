class Mail::Message
  def with_settings(settings)
    delivery_method.settings.merge!(settings)
    return self
  end
end

ActionMailer::Base.smtp_settings = {
  :address        => "smtp.sendgrid.com",
  :domain         => "allout.org",
  :port           => ENV.fetch('SENDGRID_PORT'){25},
  :user_name      => ENV["SENDGRID_USERNAME"],
  :password       => ENV["SENDGRID_PASSWORD"],
  :authentication => :plain,
  :enable_starttls_auto => false
}
