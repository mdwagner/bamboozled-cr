# Implement endpoints for Bamboo HR's Applicant Tracking System
# https://www.bamboohr.com/api/documentation/ats.php
module Bamboozled
  module API
    class ApplicantTracking < Base
      APPLICATION_STATUS_GROUPS = %w[ALL ALL_ACTIVE NEW ACTIVE INACTIVE HIRED]

      JOB_STATUS_GROUPS = %w[ALL DRAFT_AND_OPEN Open Filled Draft Deleted On\ Hold Canceled]

      # Get a list of job summaries -- GET /jobs
      def job_summaries(params = {} of String => String)
        options = Halite::Options.new(params: {
          "statusGroups" => "ALL",     # JOB_STATUS_GROUPS
          "sortBy"       => "created", # "count", "title", "lead", "created", "status"
          "sortOrder"    => "ASC",     # "ASC", "DESC"
        }.merge(params))

        request("GET", "applicant_tracking/jobs", options: options)
      end

      # Get a list of applications, following pagination -- GET /applications
      def applications(params = {} of String => String)
        page_limit = params.delete("page_limit") { 1 }

        apps = [] of JSON::Any

        1.upto page_limit do |i|
          response = request_applications(params.merge({"page" => i}))

          if response.json.try &.[]?("applications")
            apps << response.json["applications"]
          end

          break if response.json.try &.[]?("paginationComplete")
        end

        apps
      end

      # Get the details of an application -- GET /applications/:id
      def application(applicant_id)
        request("GET", "applicant_tracking/applications/#{applicant_id}")
      end

      # Add comments to an application -- POST /applications/:id/comments
      def add_comment(applicant_id, comment)
        options = Halite::Options.new(
          json: {
            "type"    => "comment",
            "comment" => comment,
          },
          headers: {
            "Content-Type" => "application/json",
          }
        )

        request("POST", "applicant_tracking/applications/#{applicant_id}/comments", options: options)
      end

      # Get a list of statuses for a company -- GET /statuses
      def statuses
        request("GET", "applicant_tracking/statuses")
      end

      # Change applicant's status -- POST /applications/:id/status
      def change_status(applicant_id, status_id)
        options = Halite::Options.new(
          json: {
            "status" => status_id.to_i,
          },
          headers: {
            "Content-Type" => "application/json",
          }
        )

        request("POST", "applicant_tracking/applications/#{applicant_id}/status", options: options)
      end

      protected def request_applications(params = {} of String => String)
        # Also supported:
        # page, jobId, applicationStatusId, applicationStatus (APPLICATION_STATUS_GROUPS),
        # jobStatusGroups (JOB_STATUS_GROUPS), searchString
        options = Halite::Options.new(params: {
          "sortBy"    => "created_date", # "first_name", "job_title", "rating", "phone", "status", "last_updated", "created_date"
          "sortOrder" => "ASC",          # "ASC", "DESC"
        }.merge(params))

        request("GET", "applicant_tracking/applications", options: options)
      end
    end
  end
end
