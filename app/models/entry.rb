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
#  index_entries_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Entry < ApplicationRecord
  paginates_per 12
  has_rich_text :content, encrypted: true
  encrypts :title
  include Recoverable

  scope :published,   ->  {where(status: "published")}
  scope :drafts,      ->  {where(status: "draft")}
  scope :empty, -> {
    left_outer_joins(:mentions, :pictures)
    .where(title: [nil, ''])
    .where(content_plain: [nil, ''])
    .where(mentions: { id: nil })
    .where(pictures: { id: nil })
  }
  scope :not_empty, -> {
    left_outer_joins(:mentions, :pictures)
    .where.not(title: [nil, ''])
    .or(where.not(content_plain: [nil, '']))
    .or(where.not(mentions: { id: nil }))
    .or(where.not(pictures: { id: nil }))
  }

  has_many(
    :mentions,
    class_name: "Mention",
    foreign_key: :entry_id,
    inverse_of: :entry,
    dependent: :destroy
  )
  accepts_nested_attributes_for :mentions, allow_destroy: true
  has_many :pictures, dependent: :destroy
  accepts_nested_attributes_for :pictures, allow_destroy: true

  has_many :people, through: :mentions
  has_many :lesson_applications
  has_many :lessons, through: :lesson_applications
  has_many :milestones

  belongs_to(
    :user,
    class_name: "User",
    foreign_key: :user_id,
    inverse_of: :entries
  )

  before_create :init_status
  before_save :cache_plain_content, :update_published_at

  def published?
    status == 'published'
  end

  def draft?
    status == 'draft'
  end

  def empty?
    title.blank? &&
    content_plain.blank? &&
    mentions.count == 0 &&
    pictures.count == 0
  end

  def last_updated_caption
    if published?
      if published_at.nil?
        "Published at an unknown date"
      else
        "Published #{published_at.strftime("%b %d, %Y")}"
      end
    else
      "Saved #{updated_at.strftime("%b %d, %Y")}"
    end
  end

  private

  def cache_plain_content
    self.content_plain = content.body.to_plain_text.strip unless content.blank?
  end

  def update_published_at
    if status_changed? && published?
      self.published_at = DateTime.now if published_at.blank?
    end
  end

  def init_status
    self.status = 'draft' if status.blank?
  end
end
