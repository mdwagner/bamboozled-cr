require "../../spec_helper.cr"

Spectator.describe Bamboozled::API::Report do
  include Mocks

  context "#custom" do
    fixture "spec/fixtures/custom_report.json"
    subject { client.report.custom(%w[bestEmail employeeNumber birthday]).json }

    it "creates a custom report" do
      is_expected.to_not be_nil
      expect(subject.not_nil!["employees"].size).to eq(2)
    end
  end
end
