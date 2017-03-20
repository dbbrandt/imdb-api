require 'rest-client'
require 'json'
require 'dotenv'

Dotenv.load

class Imdb
  attr_accessor :name, :response

  def initialize(query = "/xml/find")
     @url = ENV['IMDB_API_URL'] + query
  end

  def find_person(name)
     RestClient.get @url + "?json=1&nr=1&nm=on&q=#{name}"
  end

  def actor_imdb_id(full_name, first_name, last_name)
    result = JSON.parse(find_person(full_name))
    people = result["name_popular"] || result["name_exact"] || result["name_approx"] if result
    person = people[0]
    return nil unless "#{first_name} #{last_name}".downcase == person["name"].downcase
    person["id"]
  end
end
