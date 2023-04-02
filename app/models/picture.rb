# == Schema Information
#
# Table name: pictures
#
#  id          :uuid             not null, primary key
#  description :string
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  entry_id    :uuid             not null
#
# Indexes
#
#  index_pictures_on_entry_id  (entry_id)
#
# Foreign Keys
#
#  fk_rails_...  (entry_id => entries.id)
#
class Picture < ApplicationRecord
  belongs_to :entry
  has_one_attached :file

  def as_json(args={})
    super(args.merge(
        only: [:id, :title, :description],
        methods: [:file_url],
    ))
  end

  def file_url
    Rails.application.routes.url_helpers.url_for(file)
  end
end
