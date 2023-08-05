# == Schema Information
#
# Table name: entries
#
#  id            :uuid             not null, primary key
#  content       :string
#  content_plain :string
#  deleted       :boolean
#  deleted_at    :datetime
#  published_at  :datetime
#  status        :string
#  title         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  author_id     :uuid
#
# Indexes
#
#  index_entries_on_author_id  (author_id)
#
# Foreign Keys
#
#  fk_rails_...  (author_id => users.id)
#
require 'rails_helper'

RSpec.describe Entry, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"

  describe "scopes" do
    describe "#empty" do
        it "selects entries without a title, content, mention, or picture" do
            entry = create :entry, :empty
            puts "entry.content=#{entry.content}"
            puts "entry.content.to_trix_html=#{entry.content.to_trix_html}"
            expect(Entry.empty.count).to be 1
        end
        it "does not select entries with content" do
            create :entry, content: ActionText::Content.new(Faker::Lorem.paragraphs.join("\n\n"))
            expect(Entry.empty.count).to be 0
        end
        it "does not select entries with a title" do
            create :entry, title: "Test Title"
            expect(Entry.empty.count).to be 0
        end
        it "does not select entries with pictures" do
            create :entry, num_pictures: 1 
            create :entry, num_pictures: 2
            create :entry, num_pictures: 3
            expect(Entry.empty.count).to be 0
        end
        it "does not select entries with mentions" do
            create :entry, num_mentions: 1
            create :entry, num_mentions: 2
            create :entry, num_mentions: 3
            expect(Entry.empty.count).to be 0
        end
    end

  end




  



end


