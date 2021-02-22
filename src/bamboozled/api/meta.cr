module Bamboozled
  module API
    class Meta < Base
      def users
        response = request(:get, "meta/users")
        res = response.json.try(&.as_h.values) || [] of JSON::Any
        response.copy_with(json: JSON::Any.new(res))
      end

      def fields
        request(:get, "meta/fields")
      end

      def lists
        request(:get, "meta/lists")
      end

      def tables
        response = request(:get, "meta/tables")
        res = response.json.try { |x| x["table"].as_a } || [] of JSON::Any
        response.copy_with(json: JSON::Any.new(res))
      end
    end
  end
end
