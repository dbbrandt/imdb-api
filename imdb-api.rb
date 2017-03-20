require "logger"
require "dotenv"

Dotenv.load

require './options.rb'
require "./db.rb"
require "./imdb.rb"
require "./wms.rb"
require "./omdb.rb"

actors = DB[:people].order(:name).all
LOGGER.info "Actors: #{actors.count}"

if @update_actor_imdb_id
  imdb ||= Imdb.new
  actors.each do |actor|
    id = imdb.actor_imdb_id(actor[:name], actor[:first_name], actor[:last_name])
    LOGGER.info "Actor: #{actor[:name]} IMDB ID: #{id}"
    DB[:people].where(:id => actor[:id]).update(:imdb_id => id) if actor[:imdb_id].nil?
  end
end

if @add_movies
  movies ||= Wemakesites.new
  actors.each do |actor|
    if DB[:movies].where(actor_imdb_id: actor[:id]).count == 0
      results = movies.get_movies(actor[:imdb_id])
      LOGGER.info "Actor: #{actor[:name]} Movies: #{results.count}"
      results.each do |movie|
        actor_id = actor[:id]
        title = movie['title']
        year = movie['year'][-4..-1].to_i
        url = movie['info']
        DB[:movies].insert(:actor_imdb_id => actor_id, :title => title, :year => year, :url => url)
      end
    end
  end
end

if @update_movies_imdb_id
  fix_movies = DB[:movies].where(imdb_id: nil).all
  fix_movies.each do |m|
    imdb_id = m[:url].split('/')[4]
    LOGGER.info "Movie: #{m[:title]} Imdb: #{imdb_id}"
    DB[:movies].where(:id => m[:id]).update(:imdb_id => imdb_id)
  end
end

if @update_movies_year
  movies ||= Wemakesites.new
  fix_movies = DB[:movies].where('year < 1900').all
  fix_movies.each do |m|
    year = movies.get_year(m[:imdb_id])
    LOGGER.info "Movie: #{m[:title]} Year: #{year}"
    DB[:movies].where(:id => m[:id]).update(:year => year)
  end
end

if @update_movies_from_omdb
  omdb ||= Omdb.new
  update_movies = DB[:movies].where(type: nil).all
  update_movies.each do |m|
    LOGGER.info "OMDB Lookup - Movie: #{m[:title]} IMDB_ID: #{m[:imdb_id]}"
    movie = omdb.fetch(m[:imdb_id])
    if movie['Response'] == 'True'
      LOGGER.info "OMDB Update - Movie: #{m[:title]} IMDB_ID: #{m[:imdb_id]} Type: #{movie['Type']}"
      genre       = movie['Genre']
      director    = movie['Director']
      actors      = movie['Actors']
      plot        = movie['Plot']
      awards      = movie['Awards']
      metascore   = movie['Metascore'] == 'N/A'? nil : movie['Metascore']
      imdb_rating = movie['imdbRating'] == 'N/A'? nil : movie['imdbRating']
      type        = movie['Type']
      runtime     = movie['Runtime'] == 'N/A'? nil : movie['Runtime'].to_i
      rated       = movie['rated']
      relase_date = movie['Released']  == 'N/A' ? nil : (Date.parse movie['Released'])
      country     = movie['Country']
      DB[:movies].where(:id => m[:id]).update(:genre       => genre,
                                            :director    => director,
                                            :actors      => actors,
                                            :plot        => plot,
                                            :awards      => awards,
                                            :metascore   => metascore,
                                            :imdb_rating => imdb_rating,
                                            :type        => type,
                                            :runtime     => runtime,
                                            :rated       => rated,
                                            :relase_date => relase_date,
                                            :country     => country)
      sleep(0.5)
    else
      LOGGER.info "OMDB Lookup - Movie: #{m[:title]} FAILED!!!!"
    end

  end
end
