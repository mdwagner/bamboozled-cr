module Bamboozled
  module API
    class Base
      include Bamboozled::Mixins

      property subdomain : String
      property api_key : String
      property api_version = "v1"

      def initialize(@subdomain, @api_key)
      end

      protected def request(
        http_method : HttpMethod,
        http_path : String,
        query_params : String? = nil,
        headers : HTTP::Headers? = nil,
        body : HTTP::Client::BodyType = nil
      )
        client = generate_client(query_params)
        client_response = client.exec(http_method.name, http_path, headers, body)
        response = Response.new(headers: client_response.headers)

        case client_response.status
        when .success?
          begin
            response = response.copy_with(json: JSON.parse(client_response.body))
          rescue
          end
        when .client_error?
          raise ClientError.new(client_response)
        when .server_error?
          raise ServerError.new(client_response)
        end

        response
      end

      private def generate_client(query_params = nil)
        uri = URI.parse("https://api.bamboohr.com/api/gateway.php/#{subdomain}/#{api_version}/")
        client = HTTP::Client.new(uri)

        client.basic_auth(api_key, "x")
        client.before_request do |request|
          request.headers["User-Agent"] = "Bamboozled/#{Bamboozled::VERSION}"
          request.headers["Accept"] = "application/json"
          request.headers["Content-Type"] = "application/json"

          request.query = query_params if query_params
        end

        client
      end
    end
  end
end
