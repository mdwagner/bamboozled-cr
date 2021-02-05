require "../../spec_helper.cr"

Spectator.describe Bamboozled::API::ApplicantTracking do
  include Mocks

  it "gets job summaries" do
    File.open("spec/fixtures/job_summaries.json") do |response|
      WebMock.stub(:any, /.*api\.bamboohr\.com/).to_return(response)

      jobs = client.applicant_tracking.job_summaries.json

      expect(jobs).to_not be_nil
      expect(jobs.not_nil!.size).to eq(5)
    end
  end
end
