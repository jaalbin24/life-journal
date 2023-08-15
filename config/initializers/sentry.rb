Sentry.init do |config|
  config.dsn = 'https://cb44ac11d3ba5bd0013101fabc42775e@o4505697826832384.ingest.sentry.io/4505698063941632'
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]
  
  # Set traces_sample_rate to 1.0 to capture 100%
  # of transactions for performance monitoring.
  # We recommend adjusting this value in production.
  # config.traces_sample_rate = 1.0
  # # or
  # config.traces_sampler = lambda do |context|
  #   true
  # end
end