class UpdateElasticsearchDocumentJob < ApplicationJob
  queue_as :default
  retry_on CustomError do |job, error, attempt|
    # Retry if the Elasticsearch API request fails (API is down or there are network issues)
  end
  
  
  def perform(*args)

  end
end
