module Bamboozled
  module API
    class Employee < Base

      # TODO
      def all(fields = nil)
        response = request("GET", "employees/directory")

        employees = [] of JSON::Any

        if fields.nil? || fields == :default
          # Array(response['employees'])
          employees = response.json["employees"].as_a if response.json["employees"]?
        else
          # employees = []
          # response['employees'].map{|e| e['id']}.each do |id|
          #   employees << find(id, fields)
          # end
          # employees

          # if response.json["employees"]?
        end

        employees
      end

      def find(employee_id, fields = nil)
        fields = FieldCollection.wrap(fields).to_csv

        request("GET", "employees/#{employee_id}?fields=#{fields}")
      end

      def last_changed(date = Time.parse!("2011-06-05T00:00:00+00:00", "%FT%T%:z"), type = nil)
        options = Halite::Options.new(params: {
          "since" => date.to_s("%FT%T%:z"),
        })
        options.params["type"] = type if type

        response = request("GET", "employees/changed", options: options)

        response.json["employees"]
      end

      # Tabular data
      {% for action in %w[job_info employment_status compensation dependents contacts] %}
        def {{action.id}}(id)
          request("GET", "employees/#{id}/tables/{{ action.camelcase(lower: true).id }}")
        end
      {% end %}

      def time_off_estimate(employee_id, end_date)
        end_date = end_date.strftime("%F") unless end_date.is_a?(String)
        request(:get, "employees/#{employee_id}/time_off/calculator?end=#{end_date}")
      end

      def photo_binary(employee_id)
        request(:get, "employees/#{employee_id}/photo/small")
      end

      def photo_url(employee)
        if (Float(employee) rescue false)
          e = find(employee, ['workEmail', 'homeEmail'])
          employee = e['workEmail'].nil? ? e['homeEmail'] : e['workEmail']
        end

        digest = Digest::MD5.new
        digest.update(employee.strip.downcase)
        "http://#{@subdomain}.bamboohr.com/employees/photos/?h=#{digest}"
      end

      def add(employee_details)
        details = generate_xml(employee_details)
        options = {body: details}

        request(:post, "employees/", options)
      end

      def update(bamboo_id, employee_details)
        details = generate_xml(employee_details)
        options = { body: details }

        request(:post, "employees/#{bamboo_id}", options)
      end

      private

      def generate_xml(employee_details)
        "".tap do |xml|
          xml << "<employee>"
          employee_details.each { |k, v| xml << "<field id='#{k}'>#{v}</field>" }
          xml << "</employee>"
        end
      end
    end
  end
end
