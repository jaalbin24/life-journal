class UpdateElasticsearchDocumentJob < ApplicationJob
  queue_as :default
  retry_on StandardError do |job, error, attempt|
    # Retry if the Elasticsearch API request fails (API is down or there are network issues)
  end
  
  
  def perform(model)
    model.__elasticsearch__.update_document
  end
end
