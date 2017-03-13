require "logger"
require "dotenv"

Dotenv.load

require './options.rb'
require "./db.rb"
require "./imdb.rb"

actors = DB[:people].where(:imdb_id => nil).order(:name).all
LOGGER.info "Actors: #{actors.count}"

imdb = Imdb.new

actors.each do |actor|
  id = imdb.actor_id(actor[:name])
  LOGGER.info "Actor: #{actor[:name]} IMDB ID: #{id}"
  DB[:people].where(:id => actor[:id]).update(:imdb_id => id)
end