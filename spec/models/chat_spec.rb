# == Schema Information
#
# Table name: chats
#
#  id         :uuid             not null, primary key
#  status     :string
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  entry_id   :uuid             not null
#  user_id    :uuid             not null
#
# Indexes
#
#  index_chats_on_entry_id  (entry_id)
#  index_chats_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (entry_id => entries.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Chat, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
