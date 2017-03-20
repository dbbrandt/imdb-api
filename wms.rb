require 'rest-client'
require 'json'
require 'dotenv'

Dotenv.load

class Wms
  attr_accessor :imdb_id, :response

  def initialize()
    @url = ENV['WMS_MOVIES_API_URL']
    @api_key = ENV['WMS_MOVIES_API_KEY']
  end

  def get_movies(actor_imdb_id)
     @imdb_id = actor_imdb_id
     @response = RestClient.get @url + "#{@imdb_id}?api_key=#{@api_key}"
     JSON.parse(@response)['data']['filmography']
  end

  def get_year(movie_imdb_id)
    @imdb_id = movie_imdb_id
    @response = RestClient.get @url + "#{@imdb_id}?api_key=#{@api_key}"
    released = JSON.parse(@response)['data']['released']
    return released[0..3] if released
  end
end
