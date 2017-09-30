set :stage, :production
set :rails_env, :production
server '54.212.196.207', user: 'namnh', port: 22, roles: %{app web db}, primary: true