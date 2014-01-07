env = ENV["RACK_ENV"] || "development"

connection_string = ENV["DATABASE_URL"] || "postgres://localhost/bookmark_manager_#{env}"

DataMapper.setup(:default, connection_string )

DataMapper.finalize

