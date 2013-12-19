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