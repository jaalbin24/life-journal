# == Schema Information
#
# Table name: quotes
#
#  id                       :uuid             not null, primary key
#  author                   :string
#  content                  :string
#  deleted                  :boolean
#  deleted_at               :datetime
#  description              :string
#  last_quote_of_the_day_at :datetime
#  source                   :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
# Indexes
#
#  index_quotes_on_deleted     (deleted)
#  index_quotes_on_deleted_at  (deleted_at)
#
class Quote < ApplicationRecord

  scope :eligible_for_quote_of_the_day, -> { where("last_quote_of_the_day_at < ?", 60.days.ago).or(where(last_quote_of_the_day_at: nil)) }

  def citation
    [author, source].reject(&:blank?).join(", ") || "Unknown"
  end
end
