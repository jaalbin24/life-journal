ENV['ELASTICSEARCH_USERNAME'] ||= Rails.application.credentials.elasticsearch[:username]
ENV['ELASTICSEARCH_PASSWORD'] ||= Rails.application.credentials.elasticsearch[:password]

raise StandardError.new "elasticsearch username is missing" unless ENV['ELASTICSEARCH_USERNAME']
raise StandardError.new "elasticsearch password is missing" unless ENV['ELASTICSEARCH_PASSWORD']

Elasticsearch::Model.client = Elasticsearch::Client.new(
  log: true,
  host: ( ENV['ELASTICSEARCH_URL'] || 'http://localhost:9200' ),
  user: ENV['ELASTICSEARCH_USERNAME'],
  password: ENV['ELASTICSEARCH_PASSWORD'],
)