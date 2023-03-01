# == Schema Information
#
# Table name: entries
#
#  id           :bigint           not null, primary key
#  published_at :datetime
#  text_content :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  author_id    :bigint
#
# Indexes
#
#  index_entries_on_author_id  (author_id)
#
# Foreign Keys
#
#  fk_rails_...  (author_id => users.id)
#
class Entry < ApplicationRecord

    has_rich_text :text_content

    belongs_to(
        :author,
        class_name: "User",
        foreign_key: :author_id,
        inverse_of: :entries
    )

end
