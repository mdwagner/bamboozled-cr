require "../../spec_helper.cr"

Spectator.describe Bamboozled::API::TimeTracking do
  include Mocks

  context "#record" do
    context "api success" do
      fixture "spec/fixtures/time_tracking_record_200_response.json"
      subject { client.time_tracking.record("37_2301_REG").json }

      it "gets the given record" do
        is_expected.to_not be_nil
        expect(subject.not_nil!["payRate"].as_s).to eq("19.0000")
        expect(subject.not_nil!["employeeId"].as_s).to eq("40488")
      end
    end

    context "api failures" do
      context "bad api key" do
        fixture "spec/fixtures/time_tracking_record_401_response.json", 401

        it "should raise an error" do
          expect {
            client.time_tracking.record("37_2301_REG")
          }.to raise_error(Bamboozled::ClientError, "Your API key is missing.")
        end
      end

      context "invalid company name" do
        fixture "spec/fixtures/time_tracking_record_404_response.json", 404

        it "should raise an error" do
          expect {
            client.time_tracking.record("37_2301_REG")
          }.to raise_error(Bamboozled::ClientError, "The resource was not found with the given identifier. Either the URL given is not a valid API or the ID of the object specified in the request is invalid.")
        end
      end

      context "invalid time tracking id" do
        fixture "spec/fixtures/time_tracking_record_400_response.json", 400

        it "should raise an error" do
          expect {
            client.time_tracking.record("37_2301_REG")
          }.to raise_error(Bamboozled::ClientError, "The request was invalid or could not be understood by the server. Resubmitting the request will likely result in the same error.")
        end
      end
    end
  end
end
