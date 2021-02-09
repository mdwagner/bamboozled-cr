require "../../spec_helper.cr"

Spectator.describe Bamboozled::API::FieldCollection do
  subject { described_class.new(%w[hireDate location]) }

  context "#to_csv" do
    it "returns the fields as a csv" do
      expect(subject.to_csv).to eq "hireDate,location"
    end
  end
end
