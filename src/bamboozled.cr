module Bamboozled
  VERSION = "0.1.0"

  # Creates a standard client that will raise all errors it encounters
  def self.client(subdomain : String?, api_key : String?, http_options : Hash)
    Bamboozled::Base.new(subdomain, api_key, http_options)
  end
end
