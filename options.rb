require "slop"

LOGGER = Logger.new(STDOUT)
LOGGER.level = Logger::INFO

@test = false
@update_imdb_id = false
@add_movies = false
@update_movies_year = false

# Managed the command line arguments
opts = Slop.parse do |o|
  o.on '--test', 'run with default values' do
    @test = true
  end
  o.on '--debug', 'run in debug mode' do
    LOGGER.level = Logger::DEBUG
  end
  o.on '-v', '--version', 'print the version' do
    puts '1.0'
  end
  o.on '--actor_imdb-id', 'update actor imdb_id' do
    @update_imdb_id = true
  end
  o.on '--movies', 'add movies for actors with no movies' do
    @add_movies = true
  end
  o.on '--year', 'updete year on movies with bad of missing year' do
    @update_movies_year = true
  end
  o.on '--omdb', 'updete movies from omdb data' do
    @update_movies_from_omdb = true
  end
  o.on '--movie_imdb_id', 'updete indb_id on movies from url' do
    @update_movies_imdb_id = true
  end
end

if @test
  puts "test mode"
else
  puts "test mode off"
end

LOGGER.debug("Debugging on") if LOGGER.level == Logger::DEBUG
