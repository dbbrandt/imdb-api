require "logger"
require "dotenv"

Dotenv.load

require './options.rb'
require "./db.rb"
require "./imdb.rb"

@actors = DB[:people].all
LOGGER.info "Actors: #{@actors.count}"

