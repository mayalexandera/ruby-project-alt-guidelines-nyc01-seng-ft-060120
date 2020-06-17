require 'bundler'
Bundler.require

APP_ID = "cac4829d"
APP_KEY = "189a3d1b1309c8ad7b658c68c4eadc2d"
ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
require_all 'lib'
#ActiveRecord::Base.logger = nil