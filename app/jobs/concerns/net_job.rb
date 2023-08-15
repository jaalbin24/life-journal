module NetJob
    extend ActiveSupport::Concern

    included do
        retry_on Faraday::ConnectionFailed, Net::OpenTimeout, Net::ReadTimeout, wait: :exponentially_longer
    end
end