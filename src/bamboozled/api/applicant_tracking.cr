# Implement endpoints for Bamboo HR's Applicant Tracking System
# https://www.bamboohr.com/api/documentation/ats.php
module Bamboozled
  module API
    class ApplicantTracking < Base
      APPLICATION_STATUS_GROUPS = %w[ALL ALL_ACTIVE NEW ACTIVE INACTIVE HIRED]

      JOB_STATUS_GROUPS = %w[ALL DRAFT_AND_OPEN Open Filled Draft Deleted On\ Hold Canceled]

      # Get a list of job summaries -- GET /jobs
      def job_summaries(params = {} of String => String | Array(String))
        query_params = HTTP::Params.encode({
          "statusGroups" => "ALL",     # JOB_STATUS_GROUPS
          "sortBy"       => "created", # "count", "title", "lead", "created", "status"
          "sortOrder"    => "ASC",     # "ASC", "DESC"
        }.merge!(params))

        request(HttpMethod::Get, "applicant_tracking/jobs", query_params: query_params)
      end

      # Get a list of applications, following pagination -- GET /applications
      def applications(params = {} of String => String | Array(String))
        page_limit = params.delete("page_limit") { 1 }

        apps = [] of JSON::Any

        1.upto page_limit do |i|
          # Also supported:
          # page, jobId, applicationStatusId, applicationStatus (APPLICATION_STATUS_GROUPS),
          # jobStatusGroups (JOB_STATUS_GROUPS), searchString
          query_params = HTTP::Params.encode({
            "sortBy"    => "created_date", # "first_name", "job_title", "rating", "phone", "status", "last_updated", "created_date"
            "sortOrder" => "ASC",          # "ASC", "DESC"
          }.merge!(params.merge!({"page" => i})))

          response = request(HttpMethod::Get, "applicant_tracking/applications", query_params: query_params)

          if response.json.try &.[]?("applications")
            apps << response.json["applications"]
          end

          break if response.json.try &.[]?("paginationComplete")
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
