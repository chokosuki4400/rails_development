base = "/var/www/monofy.net/monofy"
current_path = "#{base}/current"
shared_path = "#{base}/shared"
working_directory current_path

worker_processes 2
preload_app true
timeout 30

stderr_path "#{current_path}/log/unicorn.stderr.log"
stdout_path "#{current_path}/log/unicorn.stdout.log"
listen "/tmp/unicorn.staging.sock"
pid "#{shared_path}/tmp/pids/unicorn.pid"

#ダウンタイム無し
preload_app true

before_fork do |server, worker|
  ENV['BUNDLE_GEMFILE'] = File.expand_path('Gemfile', current_path)
  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
      Process.kill(sig, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
end
