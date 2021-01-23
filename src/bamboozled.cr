require "http/client"
require "json"
require "xml"
require "uri"
require "halite"
require "./bamboozled/api/base"
require "./bamboozled/**"

module Bamboozled
  # Creates a standard client that will raise all errors it encounters
  def self.client(subdomain, api_key, http_options = nil)
    Bamboozled::Base.new(subdomain, api_key, http_options)
  end
end
