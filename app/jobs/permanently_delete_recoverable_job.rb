class PermanentlyDeleteRecoverableJob < ApplicationJob
  queue_as :default

  def perform(model)
    self.class.recoverable_classes.each do |model_class|
      model_class.deleted.deleted_before(model_class.deletion_threshold).in_batches.each_record do |record|
        record.destroy
      end
    end
  end

  def self.recoverable_classes
    [Entry, Person]
  end
end