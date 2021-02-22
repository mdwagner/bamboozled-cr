module Bamboozled
  module API
    class Employee < Base
      # https://documentation.bamboohr.com/docs/list-of-field-names
      def all(fields = [] of String)
        employees = [] of JSON::Any

        response = request(:get, "employees/directory")

        response.json.try do |json|
          employees = json["employees"].as_a

          unless fields.empty?
            employees = employees.map do |employee|
              fields << "id"
              JSON::Any.new employee.as_h.select(fields)
            end
          end
        end

        response.copy_with(json: JSON::Any.new(employees))
      end

      # https://documentation.bamboohr.com/docs/list-of-field-names
      def find(employee_id, fields = %w[firstName lastName])
        query_params = HTTP::Params.encode({
          "fields" => fields.join(","),
        })

        request(:get, "employees/#{employee_id}", query_params: query_params)
      end

      def last_changed(time, type = nil)
        params = {
          "since" => time.to_s("%FT%T%:z"),
        }
        params["type"] = type if type
        query_params = HTTP::Params.encode(params)

        request(:get, "employees/changed", query_params: query_params)
      end

      # Tabular data
      {% for action in %w[job_info employment_status compensation dependents contacts] %}
        def {{action.id}}(id)
          request(:get, "employees/#{id}/tables/{{ action.camelcase(lower: true).id }}")
        end
      {% end %}

      def time_off_estimate(employee_id, end_date : Time)
        query_params = HTTP::Params.encode({
          "end" => end_date.to_s("%F"),
        })

        request(:get, "employees/#{employee_id}/time_off/calculations", query_params: query_params)
      end

      def photo_binary(employee_id, size = "small")
        request(:get, "employees/#{employee_id}/photo/#{size}")
      end

      def add(employee_details)
        request(:post, "employees", body: employee_details.to_json)
      end

      def update(bamboo_id, employee_details)
        request(:post, "employees#{bamboo_id}", body: employee_details.to_json)
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
