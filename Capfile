# Load DSL and set up stages
require "capistrano/setup"

# Include default deployment tasks
require "capistrano/deploy"

# Include capistrano-rails
require 'capistrano/rails'
# require 'capistrano/passenger'
require 'capistrano/rvm'
require 'capistrano/bundler'
require "capistrano/scm/git"
install_plugin Capistrano::SCM::Git

require 'capistrano/rails/migrations'
require 'capistrano/rails/assets'
# require 'capistrano/nginx'
# require 'capistrano/puma'
# require 'capistrano/puma/nginx'
# require 'capistrano/upload-config'
require 'capistrano/puma'
install_plugin Capistrano::Puma
# Load custom tasks from `lib/capistrano/tasks` if you have any defined
# Dir['lib/*.rb'].each { |plugin| load(plugin) }
Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
