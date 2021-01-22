module Bamboozled
  macro custom_error(klass, super_klass = Exception, hint = "")
    class {{klass.id}} < {{super_klass.id}}
      def initialize(message = {{hint}})
        super(message)
      end
    end
  end

  class HTTPError < Exception
  end

  custom_error BadRequest, super_klass: HTTPError, hint: "The request was invalid or could not be understood by the server. Resubmitting the request will likely result in the same error."
  custom_error AuthenticationFailed, super_klass: HTTPError, hint: "Your API key is missing."
  custom_error Forbidden, super_klass: HTTPError, hint: "The application is attempting to perform an action it does not have privileges to access. Verify your API key belongs to an enabled user with the required permissions."
  custom_error NotFound, super_klass: HTTPError, hint: "The resource was not found with the given identifier. Either the URL given is not a valid API, or the ID of the object specified in the request is invalid."
  custom_error NotAcceptable, super_klass: HTTPError, hint: "The request contains references to non-existent fields."
  custom_error Conflict, super_klass: HTTPError, hint: "The request attempts to create a duplicate. For employees, duplicate emails are not allowed. For lists, duplicate values are not allowed."
  custom_error LimitExceeded, super_klass: HTTPError, hint: "The account has reached its employee limit. No additional employees could be added."
  custom_error InternalServerError, super_klass: HTTPError, hint: "The server encountered an error while processing your request and failed."
  custom_error GatewayError, super_klass: HTTPError, hint: "The load balancer or web server had trouble connecting to the Bamboo app. Please try the request again."
  custom_error ServiceUnavailable, super_klass: HTTPError, hint: "The service is temporarily unavailable. Please try the request again."
  custom_error InformBamboo, super_klass: HTTPError, hint: "An error occurred that we do not now how to handle. Please contact BambooHR."
end
