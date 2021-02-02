module Bamboozled
  module API
    class Report < Base
      def find(id, disable_dup_filtering = false)
        params = {
          "format" => "JSON",
        }
        params["fd"] = "no" if disable_dup_filtering
        query_params = HTTP::Params.encode(params)

        request(HttpMethod::Get, "reports/#{id}", query_params: query_params)
      end

      def custom(fields)
        query_params = HTTP::Params.encode({
          "format" => "JSON",
        })
        body = {
          "fields" => FieldCollection.wrap(fields).fields,
        }.to_json

        request(HttpMethod::Post, "reports/custom", query_params: query_params, body: body)
      end
    end
  end
end
