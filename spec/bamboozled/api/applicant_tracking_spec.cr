require "../../spec_helper.cr"

Spectator.describe Bamboozled::API::ApplicantTracking do
  include Mocks

  context "#job_summaries" do
    fixture "spec/fixtures/job_summaries.json"
    subject { client.applicant_tracking.job_summaries.json }

    it "gets job summaries" do
      is_expected.to_not be_nil
      expect(subject.not_nil!.size).to eq(5)
    end
  end

  context "#applicant_statuses" do
    fixture "spec/fixtures/applicant_statuses.json"
    subject { client.applicant_tracking.statuses.json }

    it "gets applicant statuses" do
      is_expected.to_not be_nil
      expect(subject.not_nil!.size).to eq(19)
    end
  end

  context "#applications" do
    fixture "spec/fixtures/applications.json"
    subject { client.applicant_tracking.applications(page_limit: 10).json }

    it "gets a list of applications" do
      is_expected.to_not be_nil
      expect(subject.not_nil!.size).to eq(13)
    end
  end

  context "#application" do
    fixture "spec/fixtures/application.json"
    subject { client.applicant_tracking.application(33).json }

    it "gets details of an application" do
      is_expected.to_not be_nil
      expect(subject.not_nil!["applicant"]["email"].as_s).to eq("nathan@efficientoffice.com")
    end
  end

  context "#change_status" do
    fixture "spec/fixtures/change_applicant_status.json"
    subject { client.applicant_tracking.change_status(33, 3).json }

    it "can change the status of an application" do
      is_expected.to_not be_nil
      expect(subject.not_nil!["type"].as_s).to eq("positionApplicantStatus")
    end
  end

  context "#add_comment" do
    fixture "spec/fixtures/application_comment.json"
    subject { client.applicant_tracking.add_comment(33, "Test comment").json }

    it "can add a comment to an application" do
      is_expected.to_not be_nil
      expect(subject.not_nil!["type"].as_s).to eq("comment")
    end
  end
end
