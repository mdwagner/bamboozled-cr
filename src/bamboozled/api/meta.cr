module Bamboozled
  module API
    class Meta < Base
      def users
        response = request(HttpMethod::Get, "meta/users")
        response.json.as_h.values
      end

      def fields
        request(HttpMethod::Get, "meta/fields")
      end

      def lists
        request(HttpMethod::Get, "meta/lists")
      end

      def tables
        response = request(HttpMethod::Get, "meta/tables")
        response.json.as_a.first
      end
    end
  end
end
