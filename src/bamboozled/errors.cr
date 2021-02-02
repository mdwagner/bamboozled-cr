module Bamboozled
  # https://documentation.bamboohr.com/docs/api-details#standard-http-responses
  private class HttpErrorBase < Exception
    @@error_types = {} of Int32 => String
    @@default_error = "An error occurred that we do not now how to handle. Please contact BambooHR."

    property response : HTTP::Client::Response

    def self.error_type(code, hint)
      @@error_types[code] = hint
    end

    def self.default_error_message(message)
      @@default_error = message
    end

    def initialize(@response)
      message = @@error_types[@response.status_code]? || @@default_error
      super(message)
    end

    def debug_message?
      @response.headers["X-BambooHR-Error-Message"]?
    end
  end

  class ClientError < HttpErrorBase
    error_type 400, "The request was invalid or could not be understood by the server. Resubmitting the request will likely result in the same error."
    error_type 401, "Your API key is missing."
    error_type 403, "The application is attempting to perform an action it does not have privileges to access. Verify your API key belongs to an enabled user with the required permissions."
    error_type 404, "The resource was not found with the given identifier. Either the URL given is not a valid API or the ID of the object specified in the request is invalid."
    error_type 406, "The request contains references to non-existent fields."
    error_type 409, "The request attempts to create a duplicate. For employees, duplicate emails are not allowed. For lists, duplicate values are not allowed."
    error_type 429, "The account has reached its employee limit. No additional employees could be added."
  end

  class ServerError < HttpErrorBase
    error_type 500, "The server encountered an error while processing your request and failed. Retrying may be appropriate."
    error_type 502, "The load balancer or web server had trouble connecting to the BambooHR app. Please try the request again."
    error_type 503, "This endpoint is currently unavailable. Retrying may be appropriate. Commonly, this is due to rate limiting, and a \"Retry-After\" header may be available."
  end
end
