module Bamboozled
  module API
    record Response,
      headers : HTTP::Headers,
      json : JSON::Any? = nil,
      xml : XML::Node? = nil

    class Base
      property subdomain : String
      property api_key : String
      property http_options = Halite::Options.new

      def initialize(@subdomain, @api_key, @http_options)
      end

      protected def request(method, path, options = nil)
        request(method, path) do |opts|
          opts.merge!(options) if options
        end
      end

      protected def request(method, path)
        client = Halite::Client.new

        client.endpoint(path_prefix)
        client.basic_auth(auth)
        client.user_agent("Bamboozled/#{Bamboozled::VERSION}")
        client.headers(accept: "application/json", content_type: "text/plain")

        options = Halite::Options.new
        yield options

        response = client.request(method, path, http_options.merge(options))

        case response.status_code
        when 200..201
          res = Response.new(headers: response.headers)

          begin
            if response.to_s
              res = res.copy_with(json: response.parse("json"))
              res = res.copy_with(xml: XML.parse(response.to_s))
            end
          rescue
          end

          res
        when 400
          raise Bamboozled::BadRequest.new
        when 401
          raise Bamboozled::AuthenticationFailed.new
        when 403
          raise Bamboozled::Forbidden.new
        when 404
          raise Bamboozled::NotFound.new
        when 406
          raise Bamboozled::NotAcceptable.new
        when 409
          raise Bamboozled::Conflict.new
        when 429
          raise Bamboozled::LimitExceeded.new
        when 500
          raise Bamboozled::InternalServerError.new
        when 502
          raise Bamboozled::GatewayError.new
        when 503
          raise Bamboozled::ServiceUnavailable.new
        else
          raise Bamboozled::InformBamboo.new
        end
      end

      private def auth
        {user: api_key, pass: "x"}
      end

      private def path_prefix
        "https://api.bamboohr.com/api/gateway.php/#{subdomain}/v1/"
      end
    end
  end
end
