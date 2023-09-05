RSpec.shared_examples Recoverable do |model_class|
  let(:model) { model_class.to_s.underscore.to_sym }

  it "implements the Recoverable concern" do
    expect(model_class.ancestors).to include Recoverable
  end

  describe "scopes" do
    describe "#deleted" do
      it "only selects deleted models" do
        3.times { create model }
        2.times { create model, deleted: true }
        expect(model_class.deleted.count).to be 2
      end
    end
    describe "#not_deleted" do
      it "only selects models which are not deleted" do
        create_list model, 3
        create_list model, 2, :deleted
        expect(model_class.not_deleted.count).to be 3
      end
    end
    describe "#deleted_before" do
      it "only selects models deleted after the given datetime" do
        create model
        create_list model, 2, :deleted, deleted_at: 10.days.ago
        create_list model, 4, :deleted, deleted_at: 40.days.ago
        expect(model_class.deleted_before(30.days.ago).count).to be 4
      end
    end
  end

  describe "callbacks" do
    describe "before_create" do
      it "calls the init_deleted method" do
        instance = build model
        expect(instance).to receive :init_deleted
        instance.save
      end
    end
    describe "after_save" do
      it "calls the handle_recovery_or_deletion method" do
        pending
        fail
      end
    end
  end

  describe "attributes" do
    describe "#deleted" do
      it "is indexed in the database" do
        expect(ActiveRecord::Migration.index_exists?(model.to_s.pluralize.to_sym, :deleted)).to be true
      end
    end
    describe "#deleted_at" do
      it "is indexed in the database" do
        expect(ActiveRecord::Migration.index_exists?(model.to_s.pluralize.to_sym, :deleted_at)).to be true
      end
    end 
  end

  describe "methods" do
    describe "#deleted?" do
      it "returns the the value of the deleted attr" do
        instance1 = create model
        instance2 = create model, :deleted
        expect(instance1.deleted?).to be false
        expect(instance2.deleted?).to be true
      end
    end
    describe "#mark_as_deleted" do
      it "sets the deleted attr to true" do
        instance = create :entry
        expect(instance.deleted).to be false
        instance.mark_as_deleted
        expect(instance.deleted).to be true
      end
      it "sets the deleted_at attr to the current time" do
        instance = build :entry
        expect(instance.deleted_at).to be nil
        instance.mark_as_deleted
        expect(instance.deleted_at).to be_within(1.second).of(Time.current)
      end
      it "does not save the model" do
        instance = build :entry
        instance.mark_as_deleted
        expect(instance.persisted?).to be false
      end
    end
    describe "#recover" do
      it "sets the deleted attr to false" do
        instance = create :entry, :deleted
        expect(instance.deleted).to be true
        instance.recover
        expect(instance.deleted).to be false
      end
      it "does not change the deleted_at attr" do
        instance = create :entry, :deleted
        expect { instance.recover }.to_not change { instance.deleted_at }
      end
      it "does not save the model" do
        instance = build :entry, :deleted
        instance.recover
        expect(instance.persisted?).to be false
      end
    end
    describe "#init_deleted" do
      it "is a private method" do
        instance = create :entry
        expect(instance.respond_to?(:init_deleted, true)).to be_truthy # The method exists
        expect { instance.init_deleted }.to raise_error NoMethodError # But it's private
      end
    end
    describe "#handle_recovery_or_deletion" do
      it "is a private method" do
        instance = create :entry
        expect(instance.respond_to?(:handle_recovery_or_deletion, true)).to be_truthy # The method exists
        expect { instance.handle_recovery_or_deletion }.to raise_error NoMethodError # But it's private
      end
      it do
        pending
        fail
      end
    end
  end

  describe "class methods" do
    describe "#TIME_TO_WAIT_BEFORE_DELETION" do
      it "defaults to 30.days if delete_after is never called" do
        expect(model_class.TIME_TO_WAIT_BEFORE_DELETION).to eq(30.days)
      end
    end
    describe "#delete_after" do
      it "sets @TIME_TO_WAIT_BEFORE_DELETION" do
        model_class.delete_after(100.years)
        expect(model_class.TIME_TO_WAIT_BEFORE_DELETION).to eq(100.years)
        model_class.delete_after(30.days) # Set it back to its default setting for future tests
      end
    end
    describe "#deletion_threshold" do
      it "returns the date before which any records marked for deletion can now be deleted" do
        model_class.delete_after(40.days)
        # They should be within a second of each other.
        expect(model_class.deletion_threshold.sec).to eq 40.days.ago.sec
      end
    end
  end
end