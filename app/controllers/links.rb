post '/links' do 
	url = params['url']
	title = params['title']
	tags = params["tags"].split(" ").map do |tag|
		#this will either find this tag or create it if it doesnt exist already
	Tag.first_or_create(:text => tag)
	Link.create(:url => url, :title => title, :tags => tags)
	redirect to('/')
	end
end

	get '/links/new' do
	  	erb :"links/new"
	end
