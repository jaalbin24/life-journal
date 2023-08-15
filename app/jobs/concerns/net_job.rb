# This concern is meant to be implemented by jobs that communicate over the network.
# It handles network-specific errors and other logic

module NetJob
    extend ActiveSupport::Concern

    included do
        retry_on Faraday::ConnectionFailed, Net::OpenTimeout, Net::ReadTimeout, wait: :exponentially_longer
    end
end