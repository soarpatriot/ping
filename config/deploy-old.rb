# config valid only for current version of Capistrano
lock '3.5.0'

set :application, 'ping'
set :repo_url, 'git@github.com:soarpatriot/ping.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'

# Default value for :scm is :git
set :scm, :git

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: 'log/capistrano.log', color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/prod.secret.exs','config/prod.exs')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, [])
  .push('deps', 'node_modules', 'rel', '_build', 'priv/static', 'log')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5
# set :phoenix_mix_env -> 'prod' #default fetch(:mix_env)
namespace :deploy do
  def is_application_running?()
    pid = capture(%Q{ps ax -o pid= -o command=|grep "rel/#{fetch(:application)}/.*/[b]eam"|awk '{print $1}'})
    return pid != ""
  end
  task :build do
    on roles(:all), in: :sequence do
      within release_path  do
        execute :mix, "deps.get && MIX_ENV=#{fetch(:mix_env)} mix ecto.migrate && MIX_ENV=#{fetch(:mix_env)} mix compile  && MIX_ENV=#{fetch(:mix_env)} mix release"
      end
    end
  end
 
  desc 'restart phoenix app'
  task :restart do
    on roles(:all), in: :sequence do
      within current_path  do

        if is_application_running?
          execute "rel/#{fetch(:application)}/bin/#{fetch(:application)}", "stop"
        end
        execute "rel/#{fetch(:application)}/bin/#{fetch(:application)}", "start -detached"
      end
    end
  end
  after :publishing, "build"
  after :published, "restart"
end

