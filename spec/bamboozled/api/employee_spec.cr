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

    let(all_with_fields) { client.employee.all(["firstName", "lastName"]) }

    it "gets all employees with specific fields" do
      expect(all_with_fields.size).to eq(2)

      all_with_fields.each do |json|
        expect(json.as_h.keys.size).to eq(3)
      end
    end
  end
end
