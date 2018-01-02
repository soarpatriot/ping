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
set :pty, true

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/prod.secret.exs','config/prod.exs')

# Default value for linked_dirs is []
# rel _build
set :linked_dirs, fetch(:linked_dirs, [])
  .push('deps', 'node_modules', 'log', '_build')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :mix_env, 'prod'
set :keep_releases, 5
# set :phoenix_mix_env -> 'prod' #default fetch(:mix_env)
 #&& MIX_ENV=#{fetch(:mix_env)} mix phoenix.digest && MIX_ENV=#{fetch(:mix_env)} mix ompile && MIX_ENV=#{fetch(:mix_env)} mix release"
set :compile_commands, "cd current\
        && MIX_ENV=#{fetch(:mix_env)} mix local.hex --force\
        && MIX_ENV=#{fetch(:mix_env)} mix local.rebar --force\
        && MIX_ENV=#{fetch(:mix_env)} mix hex.repo set hexpm --url https://hexpm.upyun.com\
        && MIX_ENV=#{fetch(:mix_env)} mix deps.get --only prod\
        && MIX_ENV=#{fetch(:mix_env)} mix ecto.create && MIX_ENV=#{fetch(:mix_env)} mix ecto.migrate"

set :commands, "cd current\
        && MIX_ENV=#{fetch(:mix_env)} iex -S mix phoenix.server"
namespace :deploy do
  task :build do
    on roles(:all), in: :sequence do
      within current_path  do
        execute :"docker", "container prune -f"
        execute :"docker-compose", "-f docker-compose-compile.yml up"
      end
    end
  end

  desc 'restart phoenix app'
  task :restart do
    invoke 'deploy:stop'
    invoke 'deploy:start'
  end
  task :start do
    on roles(:all), in: :sequence do
      within current_path  do
        #exist = capture("docker ps -a  | grep web")
        #puts "a is #{exist}"
        execute :"docker", "container prune -f"
        #if exist.empty?
        execute :"docker-compose", "up -d"
        #else
        #  execute :"docker-compose", "restart -t 30 web"
        #end
      end
    end

  end
  task :stop do
  end
  task :compose_down do
    on roles(:all), in: :sequence do
      within current_path  do
        execute :"docker-compose", "down"
        info "The applicaton is shutting down!"
        #execute :"sleep","20"
      end
    end

  end
  task :change_right do
    on roles(:all), in: :sequence do
      execute :echo, "start && sudo chown -R #{fetch(:user)} #{fetch(:deploy_to)}"
    end
  end
  task :upload do
    invoke "docker:upload_compose_compile"
    invoke "docker:upload_compose"
    invoke "docker:upload_web"
  end
  before :cleanup, :change_right
  #before :check, "docker:upload_compose"
  #before :publishing, "deploy:compose_down"
  after :published, :upload
  before :finished, :change_right
  after :finished, :build
end
