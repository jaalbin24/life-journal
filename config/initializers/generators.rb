Rails.application.config.generators do |g|
  g.orm :active_record, primary_key_type: :uuid, foreign_key_type: :uuid
end

# This file was added so all future models generated with the 'rails generate' command
# will automatically generate with a uuid.

# Added March 3, 2023 by Jeremy Albin