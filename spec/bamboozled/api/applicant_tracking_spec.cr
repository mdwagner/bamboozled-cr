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
end
