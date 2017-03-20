require 'rest-client'
require 'json'
require 'dotenv'

Dotenv.load

class Omdb
  attr_accessor :imdb_id, :response

  def initialize()
    @url = ENV['OMDB_MOVIES_API_URL']
  end

  def fetch(imdb_id)
    @imdb_id = imdb_id
    begin
      @response = RestClient::Request.execute(:method => :get, :url => @url + "?i=#{@imdb_id}&plot=full", :timeout => 5, :open_timeout => 5)
      JSON.parse(@response)
    rescue RestClient::RequestTimeout
      return {}
    end
  end
end
