require 'data_mapper'
require 'sinatra'
require 'rack-flash'

use Rack::Flash

env = ENV["RACK_ENV"] || "development"
#we're telling datamapper to use a postgres dataabse on localhost. The name will be "bookmark_manager_test" or "bookmark_manager_development" depending on the enviroment
DataMapper.setup(:default, "postgres://localhost/bookmark_manager_#{env}")

require './app/model/link' #this needs to be done after datamapper is initialised
require './app/model/tag'
require './app/model/user'
#After decalring your models, you should finalise them 
DataMapper.finalize

#However, how database tables dont exists yet. Let's tell datamapper to create them
DataMapper.auto_upgrade!

enable :sessions
set :session_secret, 'super secret'

helpers do 
	def current_user
		@current_user ||= User.get(session[:user_id]) if session[:user_id]
	end
end

get '/' do 
	@links = Link.all
	erb :index
end

post '/links' do 
	url = params['url']
	title = params['title']
	tags = params["tags"].split(" ").map do |tag|
		#this will either find this tag or create it if it doesnt exist already
		Tag.first_or_create(:text => tag)
	end
	Link.create(:url => url, :title => title, :tags => tags)
	redirect to('/')
end

get '/tags/:text' do
  tag = Tag.first(:text => params[:text])
  @links = tag ? tag.links : []
  erb :index
end


get '/users/new' do 
	#note the view is in views/users/new.rb we need the quotes because otherwise ruby would divide the symbol :users by the variable new (which makes no sense)
	@user = User.new
	erb :"users/new"
end

post '/users' do 
	# we just initialized the object without saving it. It may be invalid
	@user = User.create(:email => params[:email], :password => params[:password], :password_confirmation => params[:password_confirmation])
	#lets try saving it. If the model is valid it will be saved
	if @user.save
		session[:user_id] = @user.id
		redirect to ('/')
		#it it's not valid, we'll show the same form again
	else
		flash.now[:errors] = @user.errors.full_messages
		erb:"users/new"
	#the user.id will be nil if the user wasnt saved because of the oassword missmatch
	end
end

get '/sessions/new' do
	erb:"sessions/new"
end

post '/sessions' do 
	email, password = params[:email], params[:password]
	user = User.authenticate(email, password)
	if user
		session[:user_id] = user.id
		redirect to ('/')
	else
		flash[:errors] = ["This email or password are incorrect"]
		erb :"sessions/new"
	end	
end






