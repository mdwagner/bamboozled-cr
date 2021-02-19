require "../../spec_helper.cr"

Spectator.describe Bamboozled::API::Employee do
  include Mocks

  context "#all" do
    fixture "spec/fixtures/all_employees.json"
    subject { client.employee.all }

    it "gets all employees" do
      expect(subject.size).to eq(2)

      subject.each do |json|
        expect(json.as_h.keys.size).to eq(7)
      end
    end

    let(all_with_fields) { client.employee.all(%w[firstName lastName]) }

    it "gets all employees with specific fields" do
      expect(all_with_fields.size).to eq(2)

      all_with_fields.each do |json|
        expect(json.as_h.keys.size).to eq(3)
      end
    end
  end

  context "#find" do
    fixture "spec/fixtures/one_employee.json"
    subject { client.employee.find(1234).json }

    it "gets one employee" do
      is_expected.to_not be_nil
      employee = subject.not_nil!.as_h
      expect(employee.size).to eq(3)
      expect(employee["firstName"].as_s).to eq("John")
      expect(employee["lastName"].as_s).to eq("Doe")
    end
  end

  context "#job_info" do
    fixture "spec/fixtures/job_info.json"
    subject { client.employee.job_info(1234).json }

    it "gets employee job info" do
      is_expected.to_not be_nil
      job_info = subject.not_nil!.as_a.first
      expect(job_info["employeeId"].as_s).to eq("100")
      expect(job_info["location"].as_s).to eq("New York Office")
      expect(job_info["division"].as_s).to eq("Sprockets")
      expect(job_info["department"].as_s).to eq("Research and Development")
      expect(job_info["jobTitle"].as_s).to eq("Machinist")
      expect(job_info["reportsTo"].as_s).to eq("John Smith")
    end
  end

  context "#time_off_estimate" do
    fixture "spec/fixtures/time_off_estimate.json"
    subject {
      future = Time.local + 6.months + 1.hour
      client.employee.time_off_estimate(1234, future).json
    }

    it "gets an employee's time off estimate" do
      is_expected.to_not be_nil
      estimates = subject.not_nil!["estimates"].as_h
      expect(estimates.size).to eq(2)
      expect(estimates["end"].as_s).to eq("2014-08-31")
      expect(estimates["estimate"].size).to eq(2)
    end
  end

  context "#photo_url" do
    let(required_url) { "http://x.bamboohr.com/employees/photos?h=4fdce145bab6d27d69e34403f99fd11c" }

    sample ["me@here.com", " me@here.com ", "ME@HERE.COM"] do |email|
      it "returns the proper url using employee email address" do
        url = client.employee.photo_url(email)
        expect(url).to eq(required_url)
      end
    end
  end

  context "#add" do
    fixture "spec/fixtures/add_employee_response.json", 200, {
      "Location" => "https://api.bamboohr.com/api/gateway.php/alphasights/v1/employees/44259",
    }
    subject {
      client.employee.add({
        "firstName" => "Bruce",
        "lastName"  => "Wayne",
        "workEmail" => "bruce.wayne@gmail.com",
        "jobTitle"  => "Batman",
        "city"      => "Gotham",
      })
    }

    it "creates a new employee in BambooHR" do
      expect(subject.headers["location"]).to eq("https://api.bamboohr.com/api/gateway.php/alphasights/v1/employees/44259")
    end
  end

  context "#update" do
    fixture "spec/fixtures/update_employee_response.json", 200, {
      "Date" => "Tue, 17 Jun 2014 19:25:35 UTC",
    }
    subject {
      client.employee.update("1234", {
        "firstName" => "Bruce",
        "lastName"  => "Wayne",
        "workEmail" => "b.wayne@gmail.com",
        "jobTitle"  => "Batman",
        "city"      => "Gotham",
      })
    }

    it "updates an employee in BambooHR" do
      expect(subject.headers["date"]).to eq("Tue, 17 Jun 2014 19:25:35 UTC")
    end
  end
end
