module Bamboozled
  module API
    class Employee < Base
      def all
        request(HttpMethod::Get, "employees/directory")
      end

      def find(employee_id, fields = nil)
        query_params = HTTP::Params.encode({
          "fields" => FieldCollection.wrap(fields).to_csv,
        })

        request(HttpMethod::Get, "employees/#{employee_id}", query_params: query_params)
      end

      def last_changed(time, type = nil)
        params = {
          "since" => time.to_s("%FT%T%:z"),
        }
        params["type"] = type if type
        query_params = HTTP::Params.encode(params)

        request(HttpMethod::Get, "employees/changed", query_params: query_params)
      end

      # Tabular data
      {% for action in %w[job_info employment_status compensation dependents contacts] %}
      def {{action.id}}(id)
        request(HttpMethod::Get, "employees/#{id}/tables/{{ action.camelcase(lower: true).id }}")
      end
      {% end %}

      def time_off_estimate(employee_id, end_date : Time)
        query_params = HTTP::Params.encode({
          "end" => end_date.to_s("%F"),
        })

        request(HttpMethod::Get, "employees/#{employee_id}/time_off/calculations", query_params: query_params)
      end

      def photo_binary(employee_id, size = "small")
        request(HttpMethod::Get, "employees/#{employee_id}/photo/#{size}")
      end

      def add(employee_details)
        request(HttpMethod::Post, "employees", body: employee_details.to_json)
      end

      def update(bamboo_id, employee_details)
        request(HttpMethod::Post, "employees#{bamboo_id}", body: employee_details.to_json)
      end

      def photo_url(email, tls = false)
        uri = URI.new(
          scheme: "http",
          host: "#{subdomain}.bamboohr.com",
          path: "employees/photos",
          query: HTTP::Params.encode({
            "h" => Digest::MD5.digest(email.strip.downcase).hexstring,
          })
        )
        uri.scheme = "https" if tls
        uri.to_s
      end
    end
  end
end
