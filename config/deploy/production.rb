set :stage, :production # 部署的环境
set :branch, 'master' # 部署的代码分支
set :rails_env, :production
server '81.69.37.77', user: 'ubuntu', password: 'Q^/~24T(nhqD{y', roles: %w{web app db} , port: '22'
# server '39.98.60.180', user: 'root', password: 'Ubuntu2018', roles: %w{web app db} , port: '22'

set :deploy_to, "/var/www/xianyu_api" # 部署到服务器的位置

set :enable_ssl, false
