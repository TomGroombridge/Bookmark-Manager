#This class corresponds to a table in the databse
#We can use it to manipulate the data

class Link

	#this makes the instance of this class Datamapper resources
	include DataMapper::Resource

	has n, :tags, :through => Resource

	#This block describes what resources our model will have
	property :id, Serial #Serail means that it will be auto-incremented for every record
	property  :title, String
	property :url, String

end
