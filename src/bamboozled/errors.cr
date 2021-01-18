module Bamboozled
  alias HttpErrorParams = Hash(String, String | Halite::Options | Nil)

  class HTTPError < Exception
    getter response : Halite::Response
    getter params : HttpErrorParams

    def initialize(@response, @params)
      super(@params["response"])
    end

    def hint : String
      raise NotImplementedError.new
    end

    def to_s
      "#{self.class} : #{@response.status_code} #{@params["response"]}".tap do |msg|
        msg << "\n#{hint}"
      end
    end
  end

  class BadRequest < HTTPError
    def hint
      "The request was invalid or could not be understood by the server. Resubmitting the request will likely result in the same error."
    end
  end

  class AuthenticationFailed < HTTPError
    def hint
      "Your API key is missing."
    end
  end

  class Forbidden < HTTPError
    def hint
      "The application is attempting to perform an action it does not have privileges to access. Verify your API key belongs to an enabled user with the required permissions."
    end
  end

  class NotFound < HTTPError
    def hint
      "The resource was not found with the given identifier. Either the URL given is not a valid API, or the ID of the object specified in the request is invalid."
    end
  end

  class NotAcceptable < HTTPError
    def hint
      "The request contains references to non-existent fields."
    end
  end

  class Conflict < HTTPError
    def hint
      "The request attempts to create a duplicate. For employees, duplicate emails are not allowed. For lists, duplicate values are not allowed."
    end
  end

  class LimitExceeded < HTTPError
    def hint
      "The account has reached its employee limit. No additional employees could be added."
    end
  end

  class InternalServerError < HTTPError
    def hint
      "The server encountered an error while processing your request and failed."
    end
  end

  class GatewayError < HTTPError
    def hint
      "The load balancer or web server had trouble connecting to the Bamboo app. Please try the request again."
    end
  end

  class ServiceUnavailable < HTTPError
    def hint
      "The service is temporarily unavailable. Please try the request again."
    end
  end

  class InformBamboo < HTTPError
    def hint
      "An error occurred that we do not now how to handle. Please contact BambooHR."
    end
  end
end
