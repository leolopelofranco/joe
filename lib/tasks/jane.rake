namespace :jane do
  desc 'text sms reminder'
  task send_reminder: :environment do
    UserMailer.send_reminder
  end

  desc 'daily alarm create'
  task create_alarm_of_the_day: :environment do
    UserMailer.create_alarm_of_the_day
  end

end
