# This model only exists to support the current_user method in the authentication controller concern.
# It is purely abstract. It does not exist in the database.
class Current < ActiveSupport::CurrentAttributes
    attribute :user
end