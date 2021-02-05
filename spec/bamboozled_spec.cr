require "./spec_helper"

Spectator.describe Bamboozled do
  subject { described_class.client("x", "x") }

  it "compiles" do
    is_expected.to be_a(Bamboozled::Base)
  end
end
