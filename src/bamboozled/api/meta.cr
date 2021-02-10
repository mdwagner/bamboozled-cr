module Bamboozled
  module API
    class Meta < Base
      def users
        response = request(HttpMethod::Get, "meta/users")
        response.json.try(&.as_h.values) || [] of JSON::Any
      end

      def fields
        request(HttpMethod::Get, "meta/fields")
      end

      def lists
        request(HttpMethod::Get, "meta/lists")
      end

      def tables
        response = request(HttpMethod::Get, "meta/tables")
        response.json.try { |x| x["table"].as_a } || [] of JSON::Any
      end
    end
  end
end
