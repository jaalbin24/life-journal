class PermanentlyDeleteRecoverableJob < ApplicationJob
  queue_as :default

  def perform(model)
    if model.deleted?
      unless model.destroy
        # Notify Sentry because something prevents this model from being deleted.
      end
    end
  end
end