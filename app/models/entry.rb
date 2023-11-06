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
class Entry < ApplicationRecord
  include Recoverable
  include Searchable
  searches :content_plain, :title
  paginates_per 9
  belongs_to :user
  has_rich_text :content, encrypted: true
  encrypts :title, deterministic: true
  
  scope :published,   ->  {where(status: "published")}
  scope :drafts,      ->  {where(status: "draft")}

  has_many :mentions, dependent: :destroy
  accepts_nested_attributes_for :mentions, allow_destroy: true
  has_many :people, through: :mentions
  has_many :chats
  has_many :messages, through: :chats

  before_create :init_status
  before_save :cache_plain_content, :update_published_at

  # validate :attachments_must_be_images

  def published?
    status == 'published'
  end

  def draft?
    status == 'draft'
  end

  def summarize
    "Title #{title}\\nStatus: #{status}\\nLast saved: #{updated_at}"
  end

  private

  def attachments_must_be_images
    return unless content.attached?

    content.attachments.each do |attachment|
      if !attachment.image?
        errors.add(:content, "should only contain image attachments")
        break
      end
    end
  end

  def cache_plain_content
    self.content_plain = content.body.to_plain_text.strip unless content.blank?
  end

  def update_published_at
    if status_changed? && published?
      self.published_at = DateTime.current if published_at.blank?
    end
  end

  def init_status
    self.status = 'draft' if status.blank?
  end
end
