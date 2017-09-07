class UserNotifier < ActionMailer::Base
  default from: 'notifications@anytimefitness.com'

  # send a signup email to the user, pass in the user object that   contains the user's email address
  def welcome_email(user)

    @user = user
    Rails.logger.info 'hello'
    emails = ['leolopelofranco@gmail.com', 'leo@palmsolutions.co']

    mail(to: user["to"], subject: user["subject"])

  end

  def reservation_email(user)

    @user = user
    emails = ['leolopelofranco@gmail.com', 'leo@palmsolutions.co']

    mail(to: user["to"], subject: user["subject"])

  end

end
