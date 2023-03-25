# == Schema Information
#
# Table name: entries
#
#  id           :uuid             not null, primary key
#  deleted_at   :datetime
#  published_at :datetime
#  status       :string
#  text_content :string
#  title        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  author_id    :uuid
#
# Indexes
#
#  index_entries_on_author_id  (author_id)
#
# Foreign Keys
#
#  fk_rails_...  (author_id => users.id)
#
require "test_helper"

class EntryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
