require "sequel"
require "pg"

default_param = CONFIG_DB_CONNECT_PARAM = {
    adapter:  ENV['API_DB_ADAPTER'],
    host:     ENV['API_DB_HOST'],
    port:     ENV['API_DB_PORT'],
    database: ENV['API_DB_DATABASE'],
    user:     ENV['API_DB_USER'],
    password: ENV['API_DB_PASS']
}

DB = Sequel.connect(default_param)

LOGGER.info("Database connection: #{DB.inspect}")