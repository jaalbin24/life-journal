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

# Initialize the model-index mappings for all
# models that include the Searchable concern.
# Rails.application.config.after_initialize do
#   # We need to check that this is the right process because starting the server with foreman will
#   # make all the worker processes reach out to the Elasticsearch server too.
#   if Rails.env.test?
#     # Load all models to ensure they are recognized by Rails at this point in the start up process.
#     Dir[Rails.root.join('app', 'models', '**', '*.rb')].sort.each { |file| require file }

#     # Iterate through the models
#     ApplicationRecord.descendants.each do |model|
#       # Select the ones that implement the Searchable concern
#       if model.included_modules.include?(Searchable)
#         # Initialize the index on those models
#         model.rebuild_elasticsearch_index
#       end
#     end
#   end
# end