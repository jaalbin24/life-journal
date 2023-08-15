class UpdateElasticsearchDocumentJob < ApplicationJob
  queue_as :default
  include NetJob

  def perform(model)
    model.__elasticsearch__.update_document
  end
end
