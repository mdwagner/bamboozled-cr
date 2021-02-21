module Bamboozled
  module API
    class TimeOff < Base
      def requests(
        start start_date : Time,
        end end_date : Time,
        id = nil,
        action = "view",
        employee_id = nil,
        type = nil,
        status = nil
      )
        params = {
          "action" => action,
          "start"  => start_date.to_s("%F"),
          "end"    => end_date.to_s("%F"),
        }
        params["id"] = id.to_s if id
        params["employeeId"] = employee_id.to_s if employee_id
        params["type"] = type.to_s if type
        params["status"] = status.try(&.to_s) || %w[approved denied superceded requested canceled]

        query_params = HTTP::Params.encode(params)

        request(:get, "time_off/requests", query_params: query_params)
      end

      def whos_out(start_date : Time? = nil, end_date : Time? = nil)
        params = {} of String => String
        params["start"] = start_date.to_s("%F") if start_date
        params["end"] = end_date.to_s("%F") if valid_end_date?(start_date, end_date)

        query_params = HTTP::Params.encode(params)

        request(:get, "time_off/whos_out", query_params: query_params)
      end

      private def valid_end_date?(start_date : Time?, end_date : Time?)
        return false if !start_date || !end_date

        span = end_date - start_date
        span.total_days > 0
      end
    end
  end
end
