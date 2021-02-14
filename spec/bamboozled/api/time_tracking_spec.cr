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

  context "#add" do
    context "api success" do
      fixture "spec/fixtures/time_tracking_add_200_response.json"
      subject {
        client.time_tracking.add({
          "timeTrackingId"  => "37_2302_REG",
          "employeeId"      => "40488",
          "dateHoursWorked" => "2016-08-12",
          "payRate"         => "19.00",
          "rateType"        => "REG",
          "hoursWorked"     => "4.5760",
        }).json
      }

      it "should return a hash with the id of the created record" do
        is_expected.to_not be_nil
        expect(subject.not_nil!["id"].as_s).to eq("37_2302_REG")
      end
    end

    context "api failures" do
      context "employee id does not exist" do
        fixture "spec/fixtures/time_tracking_add_empty_response.json"
        subject {
          client.time_tracking.add({
            "timeTrackingId"  => "37_2302_REG",
            "employeeId"      => "40488",
            "dateHoursWorked" => "2016-08-12",
            "payRate"         => "19.00",
            "rateType"        => "REG",
            "hoursWorked"     => "4.5760",
          })
        }

        it "should not raise an error but should not have an object in the response payload" do
          expect(subject.json).to be_nil
          expect(subject.headers["Content-Length"]).to eq("0")
        end
      end
    end
  end

  context "#adjust" do
    context "api success" do
      fixture "spec/fixtures/time_tracking_adjust_200_response.json"
      subject { client.time_tracking.adjust("37_2302_REG", "4.8").json }

      it "should return a hash with the id of the created record" do
        is_expected.to_not be_nil
        expect(subject.not_nil!["id"].as_s).to eq("37_2302_REG")
      end
    end

    context "api failures" do
      fixture "spec/fixtures/time_tracking_adjust_400_response.json", 400

      it "should return a hash with the id of the created record" do
        expect {
          client.time_tracking.adjust("37_2303_REG", "4.8")
        }.to raise_error(Bamboozled::ClientError, "The request was invalid or could not be understood by the server. Resubmitting the request will likely result in the same error.")
      end
    end
  end
end
