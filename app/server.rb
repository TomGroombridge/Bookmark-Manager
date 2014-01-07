require 'data_mapper'
require 'sinatra'
require 'rack-flash'
require 'sinatra/partial'

require_relative 'models/link'
require_relative 'models/tag'
require_relative 'models/user'

require_relative 'helpers/application'
require_relative 'data_mapper_setup'

require_relative 'controllers/user'
require_relative 'controllers/sessions'
require_relative 'controllers/links'
require_relative 'controllers/tag'
require_relative 'controllers/application'




enable :sessions
set :session_secret, 'super secret'
use Rack::Flash
set :partial_template_engine, :erb

# DataMapper.auto_upgrade!




















