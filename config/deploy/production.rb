# サーバーのIP、ログインするユーザー名、サーバーの役割
# 10022はポートを変更している場合。通常は22
server '160.16.241.243', user: 'vpsuser', roles: %w[app web], port: 10022
# set :rbenv_custom_path, '/root/.rbenv'
# set :rbenv_custom_path, '/home/vpsuser/.rbenv'
# デプロイするサーバーにsshログインする鍵の情報。サーバー編で作成した鍵のパス
# ローカルからサーバに接続する鍵
set :ssh_options, keys: '~/.ssh/sakura_deployuser'
# set :ssh_options, {
#   keys: '~/.ssh/sakura_deployuser',
#   forward_agent: true
# }
# set :linked_dirs, %w[bin log tmp/backup tmp/pids tmp/sockets vendor/bundle]
#
# shared_path = '/var/www/monofy.net.net/monofy/shared'
# set :unicorn_pid, "#{shared_path}/tmp/pids/unicorn.pid"
# set :unicorn_options, -> { '--path /staging' }
# set :unicorn_exec, -> { 'unicorn_rails' }
