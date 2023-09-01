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
#  user_id       :uuid
#
# Indexes
#
#  index_entries_on_deleted     (deleted)
#  index_entries_on_deleted_at  (deleted_at)
#  index_entries_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'
require 'models/concerns/recoverable'

RSpec.describe Entry, type: :model do

  it_behaves_like Recoverable, Entry

  describe "scopes" do
    describe "#published" do
      it "selects published entries" do
        create :entry, :published
        expect(Entry.published.count).to be 1
      end
      it "will select deleted entries too" do
        create :entry, :published, :deleted
        expect(Entry.published.count).to be 1
      end
      it "will not select drafts" do
        create :entry, :draft
        expect(Entry.published.count).to be 0
      end
    end
    describe "#drafts" do
      it "selects drafts" do
        create :entry, :draft
        expect(Entry.drafts.count).to be 1
      end
      it "will select deleted entries too" do
        create :entry, :draft, :deleted
        expect(Entry.drafts.count).to be 1
      end
      it "will not select published entries" do
        create :entry, :published
        expect(Entry.drafts.count).to be 0
      end
    end
  end
  describe "attributes" do
    describe "#title" do
      it "is encrypted deterministically" do
        title = "The Test Title"
        e = create :entry, title: title
        expect(Entry.encrypted_attributes).to include :title
        # Models are only searchable on encrypted attributes when encrypted deterministically
        expect(Entry.find_by(title: title)).to eq e
      end
      it "preserves capitalization" do
        title = "The Test Title"
        e = create :entry, title: title
        expect(e.title).to eq title
      end
      it "returns a string" do
        e = create :entry, title: "Once Upon a Time..."
        expect(e.title).to be_a String
      end
    end
    describe "#content" do
      it "is encrypted" do
        e = create :entry
        expect(e.content.encrypted_attribute? :body).to be true
      end
      it "returns an encrypted ActionText object" do
        e = create :entry, content: "Once Upon a Time..."
        expect(e.content).to be_a ActionText::EncryptedRichText
      end
    end
    it "contains no unexpected attributes" do
      expected_attributes = [
        :id,
        :published_at,
        :deleted,
        :deleted_at,
        :title,
        :content,
        :content_plain,
        :status,
        :user_id,
        :created_at,
        :updated_at
      ]
      unexpected_attributes = Entry.new.attributes.keys.map(&:to_sym) - expected_attributes
      expect(unexpected_attributes).to be_empty, "Unexpected attributes found: #{unexpected_attributes.join(' ')}"
    end
  end
  describe "methods" do
    describe "#published?" do
      it "returns true if the entry is published" do
        e = create :entry, :published
        expect(e.published?).to be true
      end
      it "returns true if the entry is published even if the entry is deleted" do
        e = create :entry, :published, :deleted
        expect(e.published?).to be true
      end
      it "returns false if the entry is not published" do
        e = create :entry, :draft
        expect(e.published?).to be false
      end
    end
    describe "#draft?" do
      it "returns true if the entry is a draft" do
        e = create :entry, :draft
        expect(e.draft?).to be true
      end
      it "returns true if the entry is a draft even if the entry is deleted" do
        e = create :entry, :draft, :deleted
        expect(e.draft?).to be true
      end
      it "returns false if the entry is not a draft" do
        e = create :entry, :published
        expect(e.draft?).to be false
      end
    end
  end
  describe "callbacks" do
    describe "before_create" do
      it "calls init_status method" do
        e = build :entry
        expect(e).to receive(:init_status)
        e.save
      end
    end
    describe "before_save" do
      it "calls cache_plain_content" do
        e = create :entry
        expect(e).to receive(:cache_plain_content)
        e.save
      end
      it "update_published_at" do
        e = create :entry
        expect(e).to receive(:update_published_at)
        e.save
      end
    end
  end
  describe "associations" do
    describe "#mentions" do
      it "returns all mention objects related to the entry" do
        e = create :entry, num_mentions: 3
        expect(e.mentions.count).to be 3
        expect(e.mentions.first.class).to be Mention
      end
      it "are not required to create the entry" do
        e = build :entry, mentions: []
        expect(e.valid?).to be true
        expect(e.save).to be true
      end
      it "are deleted when the entry is deleted" do
        e = create :entry, num_mentions: 3
        m_ids = e.mentions.pluck(:id)
        expect(Entry.exists? e.id).to be true
        m_ids.each { |id| expect(Mention.exists? id).to be true }
        expect(e.destroy).to be_truthy
        expect(Entry.exists? e.id).to be false
        m_ids.each { |id| expect(Mention.exists? id).to be false }
      end
    end
    describe "#pictures" do
      it "returns all picture objects related to the entry" do
        e = create :entry, num_pictures: 3
        expect(e.pictures.count).to be 3
        expect(e.pictures.first.class).to be Picture
      end
      it "are not required to create the entry" do
        e = build :entry, pictures: []
        expect(e.valid?).to be true
        expect(e.save).to be true
      end
      it "are deleted when the entry is deleted" do
        e = create :entry, num_pictures: 3
        p_ids = e.pictures.pluck(:id)
        expect(Entry.exists? e.id).to be true
        p_ids.each { |id| expect(Picture.exists? id).to be true }
        expect(e.destroy).to be_truthy
        expect(Entry.exists? e.id).to be false
        p_ids.each { |id| expect(Picture.exists? id).to be false }
      end
    end
    describe "#people" do
      it "returns all person objects related to the entry" do
        e = create :entry, num_mentions: 3
        expect(e.people.count).to be 3
        expect(e.people.first.class).to be Person
      end
      it "does not accept nested attributes" do
        expect { Entry.new(people_attributes: []) }.to raise_error ActiveModel::UnknownAttributeError
      end
      it "are not required to create the entry" do
        e = build :entry, num_mentions: 0
        expect(e.valid?).to be true
        expect(e.save).to be true
      end
      it "are not deleted when the entry is deleted" do
        e = create :entry, num_mentions: 3
        p_ids = e.people.pluck(:id)
        expect(Entry.exists? e.id).to be true
        expect(e.destroy).to be_truthy
        expect(Entry.exists? e.id).to be false
        p_ids.each { |id| expect(Person.exists? id).to be true }
      end
    end
    describe "#user" do
      it "returns the user object related to the entry" do
        u = create :user
        e = u.entries.create(attributes_for(:entry))
        expect(e.user).to be u
      end
      it "does not accept nested attributes" do
        expect { Entry.new(user_attributes: []) }.to raise_error ActiveModel::UnknownAttributeError
      end
      it "is required to create the entry" do
        e = build :entry, user: nil
        expect(e.valid?).to be false
        expect(e.save).to be false
        e.user = create :user
        expect(e.valid?).to be true
        expect(e.save).to be true
      end
      it "is not deleted when the entry is deleted" do
        e = create :entry
        u_id = e.user.id
        expect(Entry.exists? e.id).to be true
        expect(e.destroy).to be_truthy
        expect(Entry.exists? e.id).to be false
        expect(User.exists? u_id).to be true
      end
    end
  end
  describe "validations" do
    # The entry model has no validations
  end
end
