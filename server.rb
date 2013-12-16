require 'data_mapper'
require 'sinatra'

env = ENV["RACK_ENV"] || "development"
#we're telling datamapper to use a postgres dataabse on localhost. The name will be "bookmark_manager_test" or "bookmark_manager_development" depending on the enviroment
DataMapper.setup(:default, "postgres://localhost/bookmark_manager_#{env}")

require './app/model/link' #this needs to be done after datamapper is initialised

#After decalring your models, you should finalise them 
DataMapper.finalize

#However, how database tables dont exists yet. Let's tell datamapper to create them
DataMapper.auto_upgrade!

get '/' do 
	@links = Link.all
	erb :index
end

post '/links' do 
	url = params['url']
	title = params['title']
	Link.create(:url => url, :title => title)
	redirect to('/')
end