require 'rails_helper'

# This job is tested with the Entry model
RSpec.describe PermanentlyDeleteRecoverableJob, type: :job do
  it "destroys the model passed to it" do
    e = create :entry, :deleted
    PermanentlyDeleteRecoverableJob.perform_now(e)
    expect { e.reload }.to raise_error(ActiveRecord::RecordNotFound)
  end
  it "will only destroy the model it it is marked for deletion" do
    e = create :entry
    PermanentlyDeleteRecoverableJob.perform_now(e)
    expect(e.reload).to be_truthy
    e.mark_as_deleted
    PermanentlyDeleteRecoverableJob.perform_now(e)
    expect { e.reload }.to raise_error(ActiveRecord::RecordNotFound)
  end
end
