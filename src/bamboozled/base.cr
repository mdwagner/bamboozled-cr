module Bamboozled
  class Base
    property subdomain : String
    property api_key : String

    def initialize(@subdomain, @api_key)
    end

    {% for feature in %w[employee report meta time_off time_tracking applicant_tracking] %}
      @{{feature.id}} : Bamboozled::API::{{feature.camelcase.id}}?

      def {{feature.id}}
        @{{feature.id}} ||= Bamboozled::API::{{feature.camelcase.id}}.new(subdomain, api_key)
      end
    {% end %}
  end
end
