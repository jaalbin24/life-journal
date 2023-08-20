require 'rails_helper'

# This job is tested with the Entry model
RSpec.describe PermanentlyDeleteRecoverableJob, type: :job do
  describe "#perform" do
    it "destroys records deleted before the deletion_threshold" do
      
    end
    it "does not destroy records deleted after the deletion_threshold" do

    end
    it "destroys deleted records" do

    end
    it "does not destroy non-deleted records" do

    end
    it "destroys Person records" do

    end
    it "destroys Entry records" do

    end
  end
  describe "#recoverable_classes" do
    it "contains the Entry class" do
      expect(PermanentlyDeleteRecoverableJob.recoverable_classes).to include Entry
    end
    it "contains the Person class" do
      expect(PermanentlyDeleteRecoverableJob.recoverable_classes).to include Person
    end
    it "does not contain any unexpected classes" do
      expected_classes = [Entry, Person]
      unexpected_classes = PermanentlyDeleteRecoverableJob.recoverable_classes - expected_classes
      expect(unexpected_classes).to be_empty
    end
  end
end
