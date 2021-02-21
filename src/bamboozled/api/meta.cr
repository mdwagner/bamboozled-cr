module Bamboozled
  module API
    class Meta < Base
      def users
        response = request(:get, "meta/users")
        response.json.try(&.as_h.values) || [] of JSON::Any
      end

      def fields
        request(:get, "meta/fields")
      end

      def lists
        request(:get, "meta/lists")
      end

      def tables
        response = request(:get, "meta/tables")
        response.json.try { |x| x["table"].as_a } || [] of JSON::Any
      end
    end
  end
end
