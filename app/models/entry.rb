# == Schema Information
#
# Table name: entries
#
#  id           :uuid             not null, primary key
#  deleted      :boolean
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
  paginates_per 12
  has_rich_text :text_content
  has_one_attached :picture_of_the_day
  include Recoverable

  scope :published,   ->  {where(status: "published")}
  scope :drafts,      ->  {where(status: "draft")}
  scope :deleted,     ->  {where(status: "deleted")}
  scope :empty, -> {
    where(
      title: ['', nil],
      text_content: ['', nil],
    )
    .left_outer_joins(:mentions, :lesson_applications, :milestones, :pictures, :rich_text_text_content)
    .group(:id)
    .having('COUNT(mentions.id) + COUNT(lesson_applications.id) + COUNT(milestones.id) + COUNT(pictures.id) + COUNT(action_text_rich_texts.id) = 0')
    .where("action_text_rich_texts.body IS NULL OR action_text_rich_texts.body = ''")
  }
  scope :not_empty, -> {
    joins("LEFT JOIN action_text_rich_texts ON action_text_rich_texts.record_id = entries.id AND action_text_rich_texts.record_type = 'Entry' AND action_text_rich_texts.name = 'text_content'")
    .where("action_text_rich_texts.body IS NOT NULL AND action_text_rich_texts.body != ''")
    .or(
      where("title != '' OR title IS NOT NULL OR text_content != '' OR text_content IS NOT NULL OR entries.id IN (
        SELECT entry_id FROM mentions
        UNION
        SELECT entry_id FROM lesson_applications
        UNION
        SELECT entry_id FROM pictures
        UNION
        SELECT entry_id FROM milestones
      )")
    )
  }

  has_many(
    :mentions,
    class_name: "Mention",
    foreign_key: :entry_id,
    inverse_of: :entry,
    dependent: :destroy
  )
  accepts_nested_attributes_for :mentions, allow_destroy: true
  has_many :pictures
  accepts_nested_attributes_for :pictures, allow_destroy: true

  has_many :people, through: :mentions
  has_many :lesson_applications
  has_many :lessons, through: :lesson_applications
  has_many :milestones

  belongs_to(
    :author,
    class_name: "User",
    foreign_key: :author_id,
    inverse_of: :entries
  )

  before_create do
    self.status = 'draft' if status.blank?
  end

  before_save do
    if status_changed? && published?
      self.published_at = DateTime.now if published_at.blank?
    end
  end

  def published?
    status == 'published'
  end
end
