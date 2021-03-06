require 'rake/testtask'

task :load_all do
  require_relative 'init.rb'
end

task :load_libraries do
  require_relative 'lib/init.rb'
end

task :print_env do
  puts "Environment: #{ENV['RACK_ENV'] || 'development'}"
end

desc 'Run all api tests'
Rake::TestTask.new(:api_spec) do |t|
  t.pattern = 'specs/api/*_spec.rb'
  t.warning = false
end

desc 'Run application console(pry)'
task :console => :print_env do
  sh 'pry -r ./specs/test_load_all'
end

desc 'Rubocop all ruby codes'
task :rubocop do
  'rubocop **/*.rb'
end

namespace :generate do
  desc 'Create rbnacl key'
  task :msg_key => :load_libraries do
    puts "New MSG_KEY (base64): #{SecureMessage.generate_key}"
  end

  desc 'Create cookie secret'
  task :session_secret => :load_libraries do
    puts "New SESSION_SECRET (base64): #{SecureSession.generate_secret}"
  end
end

namespace :session do
  desc 'Wipe all sessions stored in Redis'
  task :wipe => :load_all do
    require 'redis'
    puts 'Delete all sessions from Redis session store'
    wiped = SecureSession.wipe_redis_sessions
    puts "#{wiped.count} sessions deleted"
  end
end
