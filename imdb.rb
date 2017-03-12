require 'rest-client'
require 'json'

class Imdb
  attr_accessor :name, :response

  def initialize(query = "/xml/find")

  end

end
