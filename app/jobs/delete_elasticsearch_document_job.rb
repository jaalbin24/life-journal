class DeleteElasticsearchDocumentJob < ApplicationJob
  queue_as :default
  include Monitorable
  retry_on Faraday::ConnectionFailed, Net::OpenTimeout, Net::ReadTimeout, wait: :exponentially_longer do |job, error, attempt|
    # Log the error with prometheus
  end

  
  
  
  def perform(model)
    model.__elasticsearch__.delete_document
  end
end
