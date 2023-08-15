require 'rails_helper'

# This concern is tested using the Entry model

RSpec.describe Recoverable, type: :model do
    it "is a concern" do
        expect(Recoverable.ancestors).to include ActiveSupport::Concern
    end

    describe "scopes" do
        describe "#deleted" do
            it "only selects deleted models" do
                3.times { create :entry }
                2.times { create :entry, deleted: true }
                expect(Entry.deleted.count).to be 2
            end
        end
        describe "#not_deleted" do
            it "only selects models which are not deleted" do
                create_list :entry, 3
                create_list :entry, 2, :deleted
                expect(Entry.not_deleted.count).to be 3
            end
        end
    end
    describe "callbacks" do
        describe "before_create" do
            it "calls the init_deleted method" do
                e = build :entry
                expect(e).to receive :init_deleted
                e.save
            end
        end
    end
    describe "methods" do
        describe "#deleted?" do
            it "returns the the value of the deleted attr" do
                e1 = create :entry
                e2 = create :entry, :deleted
                expect(e1.deleted?).to be false
                expect(e2.deleted?).to be true
            end
        end
        describe "#mark_as_deleted" do
            it "sets the deleted attr to true" do
                e = create :entry
                expect(e.deleted).to be false
                e.mark_as_deleted
                expect(e.deleted).to be true
            end
            it "sets the deleted_at attr to the current time" do
                e = build :entry
                expect(e.deleted_at).to be nil
                e.mark_as_deleted
                expect(e.deleted_at).to be_within(1.second).of(Time.current)
            end
            it "saves the model" do
                e = build :entry
                expect(e.persisted?).to be false
                e.mark_as_deleted
                expect(e.persisted?).to be true
            end
            it "returns the model if the marking was successful" do
                e = create :entry
                expect(e.mark_as_deleted).to be e
            end
            it "returns false if the marking was unsuccessful" do
                e = create :entry
                allow(e).to receive(:save).and_return(false)
                expect(e.mark_as_deleted).to be false
            end
            it "enques a deletion job" do
                pending "Need to implement a background job system first"
                fail
            end
        end
        describe "#recover" do
            it "sets the deleted attr to false" do
                e = create :entry, :deleted
                expect(e.deleted).to be true
                e.recover
                expect(e.deleted).to be false
            end
            it "does not change the deleted_at attr" do
                e = create :entry, :deleted
                expect { e.recover }.to_not change { e.deleted_at }
            end
            it "saves the model" do
                e = build :entry, :deleted
                expect(e.persisted?).to be false
                e.recover
                expect(e.persisted?).to be true
            end
            it "returns the model if the recovery was successful" do
                e = create :entry, :deleted
                expect(e.recover).to be e
            end
            it "returns false if the recovery was unsuccessful" do
                e = create :entry, :deleted
                allow(e).to receive(:save).and_return(false)
                expect(e.recover).to be false
            end
            it "cancels any enqued deletion job" do
                pending "Need to implement a background job system first"
                fail
            end
        end
        describe "#init_deleted" do
            it "is a private method" do
                e = create :entry
                expect(e.respond_to?(:init_deleted, true)).to be_truthy # The method exists
                expect { e.init_deleted }.to raise_error NoMethodError # But it's private
            end
        end
    end
end