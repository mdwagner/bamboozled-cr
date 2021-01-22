# Implement endpoints for Bamboo HR's Applicant Tracking System
# https://www.bamboohr.com/api/documentation/ats.php
module Bamboozled
  module API
    class ApplicantTracking < Base
      APPLICATION_STATUS_GROUPS = %w[ALL ALL_ACTIVE NEW ACTIVE INACTIVE HIRED]

      JOB_STATUS_GROUPS = %w[ALL DRAFT_AND_OPEN Open Filled Draft Deleted On\ Hold Canceled]

      # Get a list of job summaries -- GET /jobs
      def job_summaries(params)
        query = {
          "statusGroups" => "ALL",     # JOB_STATUS_GROUPS
          "sortBy" =>       "created", # "count", "title", "lead", "created", "status"
          "sortOrder" =>    "ASC"      # "ASC", "DESC"
        }
        query.merge!(params) if params
        options = Halite::Options.new(params: query)

        request("GET", "applicant_tracking/jobs", options: options)
      end

      # Get a list of applications, following pagination -- GET /applications
      def applications(params)
        page_limit = params.delete("page_limit") { 1 }

        apps = [] of JSON::Any

        1.upto page_limit do |i|
          response = request_applications(params.merge("page" => i))

          if response.json.try &.[]?("applications")
            apps << response.json["applications"]
          end

          break if response.json.try &.[]?("paginationComplete")
        end

        apps
      end

      # Get the details of an application -- GET /applications/:id
      def application(applicant_id)
        request(:get, "applicant_tracking/applications/#{applicant_id}")
      end

      # Add comments to an application -- POST /applications/:id/comments
      def add_comment(applicant_id, comment)
        details = { type: "comment", comment: comment }.to_json
        options = { body: details, headers: { "Content-Type" => "application/json" } }

        request(:post, "applicant_tracking/applications/#{applicant_id}/comments", options)
      end

      # Get a list of statuses for a company -- GET /statuses
      def statuses
        request(:get, "applicant_tracking/statuses")
      end

      # Change applicant's status -- POST /applications/:id/status
      def change_status(applicant_id, status_id)
        details = { status: status_id.to_i }.to_json
        options = { body: details, headers: { "Content-Type" => "application/json" } }

        request(:post, "applicant_tracking/applications/#{applicant_id}/status", options)
      end

      protected

      def request_applications(params = {}) # rubocop:disable Style/OptionHash
        # Also supported:
        # page, jobId, applicationStatusId, applicationStatus (APPLICATION_STATUS_GROUPS),
        # jobStatusGroups (JOB_STATUS_GROUPS), searchString
        query = {
          "sortBy":    "created_date", # "first_name", "job_title", "rating", "phone", "status", "last_updated", "created_date"
          "sortOrder": "ASC"           # "ASC", "DESC"
        }.merge(params)

        request(:get, "applicant_tracking/applications", query: query)
      end
    end
  end
end
