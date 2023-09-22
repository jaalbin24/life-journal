if Rails.env.production?
  ENV["DB_URL"]                   = Rails.application.credentials.database.url!
  ENV["ELASTICSEARCH_URL"]        = Rails.application.credentials.elasticsearch.url!
  ENV["BUCKET_URL"]               = Rails.application.credentials.bucket.url!
  ENV["REDIS_URL"]                = Rails.application.credentials.redis.url!

  ENV["DB_USERNAME"]              = Rails.application.credentials.database.username!
  ENV["DB_PASSWORD"]              = Rails.application.credentials.database.password!

  ENV["BUCKET_SECRET_ACCESS_KEY"] = Rails.application.credentials.bucket.secret_access_key!
  ENV["BUCKET_ACCESS_KEY"]        = Rails.application.credentials.bucket.access_key!
  
  # ENV["ELASTICSEARCH_USERNAME"]   = Rails.application.credentials.elasticsearch.username!
  # ENV["ELASTICSEARCH_PASSWORD"]   = Rails.application.credentials.elasticsearch.password!
else
  ENV["DB_URL"]                   = "SOMETHING"
  ENV["ELASTICSEARCH_URL"]        = "SOMETHING"
  ENV["BUCKET_URL"]               = "SOMETHING"
  ENV["REDIS_URL"]                = "SOMETHING"

  ENV["DB_USERNAME"]              = "SOMETHING"
  ENV["DB_PASSWORD"]              = "SOMETHING"

  ENV["RAILS_MASTER_KEY"]         = "SOMETHING"
  ENV["BUCKET_SECRET_ACCESS_KEY"] = "SOMETHING"
  ENV["BUCKET_ACCESS_KEY"]        = "SOMETHING"
  ENV["ELASTICSEARCH_USERNAME"]   = "SOMETHING"
  ENV["ELASTICSEARCH_PASSWORD"]   = "SOMETHING"
end
