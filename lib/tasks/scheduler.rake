desc 'text sms reminder'
task send_reminder: :environment do
  puts 'Sending Reminder...'
  UserMailer.send_reminder
end

desc 'daily alarm create'
task create_alarm_of_the_day: :environment do
  puts 'Creating the Alarm of the Day...'
  UserMailer.create_alarm_of_the_day
end
