module Bamboozled
  module API
    class Report < Base
      def find(id, disable_dup_filtering = false)
        params = {
          "format" => "JSON",
        }
        params["fd"] = "no" if disable_dup_filtering
        query_params = URI::Params.encode(params)

        request(:get, "reports/#{id}", query_params: query_params)
      end

      # https://documentation.bamboohr.com/docs/list-of-field-names
      def custom(fields)
        query_params = URI::Params.encode({
          "format" => "JSON",
        })
        body = {
          "fields" => fields.join(","),
        }.to_json

        request(:post, "reports/custom", query_params: query_params, body: body)
      end
    end
  end
end
