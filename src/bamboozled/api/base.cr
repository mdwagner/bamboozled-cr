module Bamboozled
  module API
    class Base
      property subdomain : String
      property api_key : String
      property http_options = Halite::Options.new

      def initialize(@subdomain, @api_key, @http_options)
      end

      protected def request(
        method : String,
        path : String
      )
        client = Halite::Client.new

        client.endpoint(path_prefix)
        client.basic_auth(*auth)
        client.user_agent("Bamboozled/#{Bamboozled::VERSION}")
        client.headers(accept: "application/json")
        client.headers(content_type: "text/plain")

        options = Halite::Options.new
        yield options

        response = client.request(method, path, http_options.merge(options))
        params : HttpErrorParams = {
          "path"     => path,
          "method"   => method,
          "options"  => options,
          "response" => response.inspect.to_s,
        }

        case response.status_code
        when 200..201
          begin
            if !response.to_s
              { "headers" => response.headers }
            else
              response.parse("json")
            end
          rescue
            XML.parse(response.to_s)
          end
        when 400
          raise Bamboozled::BadRequest.new(response, params)
        when 401
          raise Bamboozled::AuthenticationFailed.new(response, params)
        when 403
          raise Bamboozled::Forbidden.new(response, params)
        when 404
          raise Bamboozled::NotFound.new(response, params)
        when 406
          raise Bamboozled::NotAcceptable.new(response, params)
        when 409
          raise Bamboozled::Conflict.new(response, params)
        when 429
          raise Bamboozled::LimitExceeded.new(response, params)
        when 500
          raise Bamboozled::InternalServerError.new(response, params)
        when 502
          raise Bamboozled::GatewayError.new(response, params)
        when 503
          raise Bamboozled::ServiceUnavailable.new(response, params)
        else
          raise Bamboozled::InformBamboo.new(response, params)
        end
      end

      private def auth
        {api_key, "x"}
      end

      private def path_prefix
        "https://api.bamboohr.com/api/gateway.php/#{subdomain}/v1/"
      end
    end
  end
end
