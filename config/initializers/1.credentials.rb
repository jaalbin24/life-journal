if Rails.env.production?
  ENV["DB_URL"]                   = Rails.application.credentials.database.url!
  ENV["ELASTICSEARCH_URL"]        = Rails.application.credentials.elasticsearch.url!
  ENV["BUCKET_URL"]               = Rails.application.credentials.bucket.url!
  ENV["REDIS_URL"]                = Rails.application.credentials.redis.url!
  ENV["DB_USERNAME"]              = Rails.application.credentials.database.username!
  ENV["DB_PASSWORD"]              = Rails.application.credentials.database.password!
  ENV["BUCKET_SECRET_ACCESS_KEY"] = Rails.application.credentials.bucket.secret_access_key!
  ENV["BUCKET_ACCESS_KEY"]        = Rails.application.credentials.bucket.access_key!
  ENV["ELASTICSEARCH_USERNAME"]   = Rails.application.credentials.elasticsearch.username!
  ENV["ELASTICSEARCH_PASSWORD"]   = Rails.application.credentials.elasticsearch.password!
  ENV["OPENAI_API_KEY"]           = Rails.application.credentials.openai.api_key!
else
  ENV["ELASTICSEARCH_URL"]        = Rails.application.credentials.elasticsearch.url!
  ENV["REDIS_URL"]                = Rails.application.credentials.redis.url!
  ENV["ELASTICSEARCH_USERNAME"]   = Rails.application.credentials.elasticsearch.username!
  ENV["ELASTICSEARCH_PASSWORD"]   = Rails.application.credentials.elasticsearch.password!
  ENV["OPENAI_API_KEY"]           = Rails.application.credentials.openai.api_key!
end
