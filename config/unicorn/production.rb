# frozen_string_literal: true

# ワーカーの数
$worker  = 2
# 何秒経過すればワーカーを削除するのかを決める
$timeout = 30
# 自分のアプリケーション名、currentがつくことに注意。
$app_dir = '/var/www/monofy.net/monofy/current'
# リクエストを受け取るポート番号を指定。後述
$listen  = '/var/www/monofy.net/monofy/shared/tmp/sockets/.unicorn.sock', $app_dir
# PIDの管理ファイルディレクトリ
$pid     = '/var/www/monofy.net/monofy/shared/tmp/pids/unicorn.pid', $app_dir
# エラーログを吐き出すファイルのディレクトリ
$std_log = '/var/www/monofy.net/monofy/shared/log', $app_dir

# 上記で設定したものが適応されるよう定義
worker_processes  $worker
working_directory $app_dir
stderr_path $std_log
stdout_path $std_log
timeout $timeout
listen  $listen
pid $pid

# ホットデプロイをするかしないかを設定
preload_app true

# fork前に行うことを定義
before_exec do |_server|
  ENV['BUNDLE_GEMFILE'] = "#{$app_dir}/Gemfile"
end

before_fork do |server, worker|
  # the following is highly recomended for Rails + "preload_app true"
  # as there's no need for the master process to hold a connection
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
  end

  # Before forking, kill the master process that belongs to the .oldbin PID.
  # This enables 0 downtime deploys.
  old_pid = "/var/www/monofy.net/monofy/shared/tmp/pids/unicorn.pid.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

after_fork do |server, worker|
  # the following is *required* for Rails + "preload_app true",
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
  end

  # if preload_app is true, then you may also want to check and
  # restart any other shared sockets/descriptors such as Memcached,
  # and Redis.  TokyoCabinet file handles are safe to reuse
  # between any number of forked children (assuming your kernel
  # correctly implements pread()/pwrite() system calls)
end