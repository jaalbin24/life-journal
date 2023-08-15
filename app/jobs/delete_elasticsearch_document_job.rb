class DeleteElasticsearchDocumentJob < ApplicationJob
  queue_as :default
  include NetJob

  def perform(model)
    model.__elasticsearch__.delete_document
  end
end
