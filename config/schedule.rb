set :output, File.join(Whenever.path, "log", "cron.log")

every 30.minutes, roles: [:app] do
  rake "publish_notes"
end