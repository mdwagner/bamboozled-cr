require "../../spec_helper.cr"

Spectator.describe Bamboozled::API::Meta do
  include Mocks

  context "#users" do
    fixture "spec/fixtures/meta_users.json"
    subject { client.meta.users.json }

    it "gets all users" do
      is_expected.to_not be_nil
      expect(subject.not_nil!.size).to eq(139)
    end
  end

  context "#fields" do
    fixture "spec/fixtures/meta_fields.json"
    subject { client.meta.fields.json }

    it "gets all fields" do
      expect(subject.not_nil!.size).to eq(196)
    end
  end

  context "#lists" do
    fixture "spec/fixtures/meta_lists.json"
    subject { client.meta.lists.json }

    it "gets the lists" do
      expect(subject.not_nil!.size).to eq(35)
    end
  end

  context "#tables" do
    fixture "spec/fixtures/meta_tables.json"
    subject { client.meta.tables.json }

    it "gets the tables" do
      is_expected.to_not be_nil
      expect(subject.not_nil!.size).to eq(13)
    end
  end
end
