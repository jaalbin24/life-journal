# == Schema Information
#
# Table name: notes
#
#  id           :uuid             not null, primary key
#  content      :string
#  deleted      :boolean
#  deleted_at   :datetime
#  notable_type :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  author_id    :uuid             not null
#  notable_id   :uuid             not null
#
# Indexes
#
#  index_notes_on_author_id  (author_id)
#  index_notes_on_notable    (notable_type,notable_id)
#
# Foreign Keys
#
#  fk_rails_...  (author_id => users.id)
#
require 'rails_helper'

RSpec.describe Note, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
