# Implement endpoints for Bamboo HR's Applicant Tracking System
# https://www.bamboohr.com/api/documentation/ats.php
module Bamboozled
  module API
    class ApplicantTracking < Base
      APPLICATION_STATUS_GROUPS = %w[ALL ALL_ACTIVE NEW ACTIVE INACTIVE HIRED]
      JOB_STATUS_GROUPS         = %w[ALL DRAFT_AND_OPEN Open Filled Draft Deleted On\ Hold Canceled]

      # Get a list of job summaries -- GET /jobs
      def job_summaries(filters = nil)
        params = {
          "statusGroups" => "ALL",     # JOB_STATUS_GROUPS
          "sortBy"       => "created", # "count", "title", "lead", "created", "status"
          "sortOrder"    => "ASC",     # "ASC", "DESC"
        }
        params.merge!(filters) if filters
        query_params = HTTP::Params.encode(params)

        request(HttpMethod::Get, "applicant_tracking/jobs", query_params: query_params)
      end

      # Get a list of applications, following pagination -- GET /applications
      def applications(filters = nil, page_limit = 1)
        apps = [] of JSON::Any

        1.upto page_limit do |i|
          # Also supported:
          # page, jobId, applicationStatusId, applicationStatus (APPLICATION_STATUS_GROUPS),
          # jobStatusGroups (JOB_STATUS_GROUPS), searchString
          params = {
            "page"      => i,
            "sortBy"    => "created_date", # "first_name", "job_title", "rating", "phone", "status", "last_updated", "created_date"
            "sortOrder" => "ASC",          # "ASC", "DESC"
          }
          params.merge!(filters) if filters
          query_params = HTTP::Params.encode(params)

          response = request(HttpMethod::Get, "applicant_tracking/applications", query_params: query_params)

          if response.json["applications"]?
            response.json["applications"].as_a.each do |app|
              apps << app
            end
          end

          break if response.json["paginationComplete"]?.try(&.as_bool)
        end

        apps
      end

      # Get the details of an application -- GET /applications/:id
      def application(applicant_id)
        request(HttpMethod::Get, "applicant_tracking/applications/#{applicant_id}")
      end

      # Add comments to an application -- POST /applications/:id/comments
      def add_comment(applicant_id, comment)
        body = {
          "type"    => "comment",
          "comment" => comment,
        }.to_json

        request(HttpMethod::Post, "applicant_tracking/applications/#{applicant_id}/comments", body: body)
      end

      # Get a list of statuses for a company -- GET /statuses
      def statuses
        request(HttpMethod::Get, "applicant_tracking/statuses")
      end

      # Change applicant's status -- POST /applications/:id/status
      def change_status(applicant_id, status_id)
        body = {
          "status" => status_id.to_i,
        }.to_json

        request(HttpMethod::Post, "applicant_tracking/applications/#{applicant_id}/status", body: body)
      end
    end
  end
end
