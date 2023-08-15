class PermanentlyDeleteRecoverableModelJob < ApplicationJob
  queue_as :default

  def perform(model)
    # Check the model's deleted status
    if model.deleted?
      
    else
      # Notify Sentry because something is queing deletion jobs for non-deleted objects.
    end
    # Do something later
  end
end
