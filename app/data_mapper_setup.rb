env = ENV["RACK_ENV"] || "development"

database_string = ENV["DATABASE_URL"] || "postgres://localhost/bookmark_manager_#{env}"

DataMapper.setup(:default, database_string)

require_relative './models/link'
require_relative './models/user'
require_relative './models/tag'

DataMapper.finalize
# DataMapper.auto_upgrade!

DataMapper.auto_migrate!