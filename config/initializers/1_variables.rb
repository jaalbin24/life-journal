Vault.configure do |config|
  # The address of the Vault server, also read as ENV["VAULT_ADDR"]
  config.address = "https://vault.home:8200"

  # Use SSL verification, also read as ENV["VAULT_SSL_VERIFY"]
  config.ssl_verify = false
end

response = Vault.auth.approle(ENV["VAULT_ROLE_ID"], ENV["VAULT_SECRET_ID"])
Vault.token = response.auth.client_token

if Rails.env.production?
  secret = Vault.logical.read("kv/life-journal")
  ENV["DB_URL"]                   ||= secret.data[:DB_URL]
  ENV["ELASTICSEARCH_URL"]        ||= secret.data[:ELASTICSEARCH_URL]
  ENV["BUCKET_URL"]               ||= secret.data[:BUCKET_URL]
  ENV["REDIS_URL"]                ||= secret.data[:REDIS_URL]

  ENV["DB_USERNAME"]              ||= secret.data[:DB_USERNAME]
  ENV["DB_PASSWORD"]              ||= secret.data[:DB_PASSWORD]

  ENV["RAILS_MASTER_KEY"]         ||= secret.data[:RAILS_MASTER_KEY]
  ENV["BUCKET_SECRET_ACCESS_KEY"] ||= secret.data[:BUCKET_SECRET_ACCESS_KEY]
  ENV["BUCKET_ACCESS_KEY"]        ||= secret.data[:BUCKET_ACCESS_KEY]
  ENV["ELASTICSEARCH_USERNAME"]   ||= secret.data[:ELASTICSEARCH_USERNAME]
  ENV["ELASTICSEARCH_PASSWORD"]   ||= secret.data[:ELASTICSEARCH_PASSWORD]
else
  
end