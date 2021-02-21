module Bamboozled
  module API
    class TimeTracking < Base
      def record(time_tracking_id)
        request(:get, "timetracking/record/#{time_tracking_id}")
      end

      def add(time_tracking_details)
        request(:post, "timetracking/add", body: time_tracking_details.to_json)
      end

      def adjust(time_tracking_id, hours_worked)
        body = {
          "timeTrackingId" => time_tracking_id,
          "hoursWorked"    => hours_worked,
        }.to_json

        request(:put, "timetracking/adjust", body: body)
      end
    end
  end
end
