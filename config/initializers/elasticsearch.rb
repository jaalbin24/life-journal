# raise StandardError.new "elasticsearch username is missing" unless ENV['ELASTICSEARCH_USERNAME']
# raise StandardError.new "elasticsearch password is missing" unless ENV['ELASTICSEARCH_PASSWORD']

Elasticsearch::Model.client = Elasticsearch::Client.new(
  log: false,
  host: ENV['ELASTICSEARCH_URL'],
  user: ENV['ELASTICSEARCH_USERNAME'],
  password: ENV['ELASTICSEARCH_PASSWORD'],
)