desc "Drain the logs until we figure out where to store them more permanently"
task :drain_logs => :environment do
  puts "Draining logs..."
  list = Rails.application.config.logger.device.list
  Rails.application.config.redis.ltrim(list, -500, -1)
  puts "done."
end
