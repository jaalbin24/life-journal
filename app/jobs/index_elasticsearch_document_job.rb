class IndexElasticsearchDocumentJob < ApplicationJob
  queue_as :default
  include NetJob

  def perform(model)
    model.__elasticsearch__.index_document
  end
end