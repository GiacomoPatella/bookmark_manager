env = ENV["RACK_ENV"] || "development"

database_string = ENV["DATABASE_URL"] || "postgres://localhost/bookmark_manager_#{env}"

DataMapper.setup(:default, database_string)

require './models/link'
require './models/user'
require './models/tag'

DataMapper.finalize
# DataMapper.auto_upgrade!

DataMapper.auto_migrate!