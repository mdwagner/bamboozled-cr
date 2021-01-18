require "http/client"
require "json"
require "xml"
require "uri"
require "halite"
require "./bamboozled/**"

module Bamboozled
  # Creates a standard client that will raise all errors it encounters
  def self.client(subdomain : String, api_key : String, http_options : Halite::Options? = nil)
    Bamboozled::Base.new(subdomain, api_key, http_options)
  end
end
