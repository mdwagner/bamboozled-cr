# Implement endpoints for Bamboo HR's Applicant Tracking System
# https://www.bamboohr.com/api/documentation/ats.php
module Bamboozled
  module API
    class ApplicantTracking < Base
      APPLICATION_STATUS_GROUPS = %w[ALL ALL_ACTIVE NEW ACTIVE INACTIVE HIRED]
      JOB_STATUS_GROUPS         = %w[ALL DRAFT_AND_OPEN Open Filled Draft Deleted On\ Hold Canceled]

      # Get a list of job summaries -- GET /jobs
      def job_summaries(param_filters = nil)
        params = {
          "statusGroups" => "ALL",     # JOB_STATUS_GROUPS
          "sortBy"       => "created", # "count", "title", "lead", "created", "status"
          "sortOrder"    => "ASC",     # "ASC", "DESC"
        }
        params.merge!(param_filters) if param_filters
        query_params = URI::Params.encode(params)

        request(:get, "applicant_tracking/jobs", query_params: query_params)
      end

      # Get a list of applications, following pagination -- GET /applications
      def applications(param_filters = nil, page_limit = 1)
        apps = [] of JSON::Any
        response = Response.new(headers: HTTP::Headers.new)

        1.upto page_limit do |i|
          # Also supported:
          # page, jobId, applicationStatusId, applicationStatus (APPLICATION_STATUS_GROUPS),
          # jobStatusGroups (JOB_STATUS_GROUPS), searchString
          params = {
            "page"      => "#{i}",
            "sortBy"    => "created_date", # "first_name", "job_title", "rating", "phone", "status", "last_updated", "created_date"
            "sortOrder" => "ASC",          # "ASC", "DESC"
          }
          params.merge!(param_filters) if param_filters
          query_params = URI::Params.encode(params)

          res = request(:get, "applicant_tracking/applications", query_params: query_params)
          response = response.copy_with(headers: res.headers, json: res.json)

          unless response.json.nil?
            json = response.json.not_nil!

            if json["applications"]?
              json["applications"].as_a.each do |app|
                apps << app
              end
            end

            break if json["paginationComplete"]?.try(&.as_bool)
          end
        end

        response.copy_with(json: JSON::Any.new(apps))
      end

      # Get the details of an application -- GET /applications/:id
      def application(applicant_id)
        request(:get, "applicant_tracking/applications/#{applicant_id}")
      end

      # Add comments to an application -- POST /applications/:id/comments
      def add_comment(applicant_id, comment)
        body = {
          "type"    => "comment",
          "comment" => comment,
        }.to_json

        request(:post, "applicant_tracking/applications/#{applicant_id}/comments", body: body)
      end

      # Get a list of statuses for a company -- GET /statuses
      def statuses
        request(:get, "applicant_tracking/statuses")
      end

      # Change applicant's status -- POST /applications/:id/status
      def change_status(applicant_id, status_id)
        body = {
          "status" => status_id.to_i,
        }.to_json

        request(:post, "applicant_tracking/applications/#{applicant_id}/status", body: body)
      end
    end
  end
end
