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
class Entry < ApplicationRecord
  has_rich_text :text_content
  has_one_attached :picture_of_the_day

  scope :published,   ->  {where(status: "published")}
  scope :drafts,      ->  {where(status: "draft")}
  scope :deleted,     ->  {where(status: "deleted")}

  has_many(
    :mentions,
    class_name: "Mention",
    foreign_key: :entry_id,
    inverse_of: :entry,
    dependent: :destroy
  )

  has_many(
    :people,
    through: :mentions
  )

  has_many :pictures

  belongs_to(
    :author,
    class_name: "User",
    foreign_key: :author_id,
    inverse_of: :entries
  )
  accepts_nested_attributes_for :mentions, allow_destroy: true

  before_create do
    self.status = 'draft' if status.blank?
  end

  before_save do
    if status_changed? && published?
      self.published_at = DateTime.now if published_at.blank?
    end
  end

  def mark_as_deleted
    self.status = "deleted"
    self.deleted_at = DateTime.now
  end

  def published?
    status == 'published'
  end
end
