require "http/client"
require "http/params"
require "json"
require "xml"
require "uri"
require "digest/md5"
require "./bamboozled/version"
require "./bamboozled/errors"
require "./bamboozled/mixins"
require "./bamboozled/api/base"
require "./bamboozled/api/field_collection"
require "./bamboozled/api/*"
require "./bamboozled/base"

module Bamboozled
  # Creates a standard client that will raise all errors it encounters
  def self.client(subdomain, api_key)
    Bamboozled::Base.new(subdomain, api_key)
  end
end
