# frozen_string_literal: true

# # config valid for current version and patch releases of Capistrano
lock '~> 3.11.0'
#
# set :application, "my_app_name"
# set :repo_url, "git@example.com:me/my_repo.git"
#
# # Default branch is :master
# # ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp
#
# # Default deploy_to directory is /var/www/my_app_name
# # set :deploy_to, "/var/www/my_app_name"
#
# # Default value for :format is :airbrussh.
# # set :format, :airbrussh
#
# # You can configure the Airbrussh format using :format_options.
# # These are the defaults.
# # set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto
#
# # Default value for :pty is false
# # set :pty, true
#
# # Default value for :linked_files is []
# # append :linked_files, "config/database.yml"
#
# # Default value for linked_dirs is []
# # append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"
#
# # Default value for default_env is {}
# # set :default_env, { path: "/opt/ruby/bin:$PATH" }
#
# # Default value for local_user is ENV['USER']
# # set :local_user, -> { `git config user.name`.chomp }
#
# # Default value for keep_releases is 5
# # set :keep_releases, 5
#
# # Uncomment the following to require manually verifying the host key before first deploy.
# # set :ssh_options, verify_host_key: :secure

# capistranoのバージョン固定
# lock "~> 3.10.1"

# デプロイするアプリケーション名
set :application, 'monofy'

# cloneするgitのレポジトリ
# 1-3で設定したリモートリポジトリのurl
set :repo_url, 'https://github.com/y-onishi4400/monofy.git'

# deployするブランチ。デフォルトはmasterなのでなくても可。
set :branch, 'master'

# deploy先のディレクトリ。
set :deploy_to, '/var/www/monofy.net/monofy'

set :pty, true
set :rbenv_type, :system

# シンボリックリンクをはるファイル
set :linked_files, fetch(:linked_files, []).push('config/secrets.yml')

# シンボリックリンクをはるフォルダ
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

set :default_env, { path: "/usr/local/rbenv/shims:/usr/local/rbenv/bin:$PATH" }

# 保持するバージョンの個数
set :keep_releases, 5

# rubyのバージョン
# rbenvで設定したサーバー側のrubyのバージョン
set :rbenv_ruby, '2.5.1'

# 出力するログのレベル。
set :format, :pretty
set :log_level, :debug

# デプロイのタスク
namespace :deploy do
  # 上記linked_filesで使用するファイルをアップロードするタスク
  desc 'Upload database.yml'
  task :upload do
    on roles(:app) do |_host|
      execute "mkdir -p #{shared_path}/config" if test "[ ! -d #{shared_path}/config ]"
      upload!('config/database.yml', "#{shared_path}/config/database.yml")
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app) do
      invoke 'unicorn:restart'
    end
  end
end

# linked_filesで使用するファイルをアップロードするタスクは、deployが行われる前に実行する必要がある
before 'deploy:starting', 'deploy:upload'
# Capistrano 3.1.0 からデフォルトで deploy:restart タスクが呼ばれなくなったので、ここに以下の1行を書く必要がある
after 'deploy:publishing', 'deploy:restart'
