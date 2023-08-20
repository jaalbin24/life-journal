# == Schema Information
#
# Table name: pictures
#
#  id          :uuid             not null, primary key
#  deleted     :boolean
#  deleted_at  :datetime
#  description :string
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  entry_id    :uuid             not null
#  user_id     :uuid             not null
#
# Indexes
#
#  index_pictures_on_entry_id  (entry_id)
#  index_pictures_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (entry_id => entries.id)
#  fk_rails_...  (user_id => users.id)
#
class Picture < ApplicationRecord
  belongs_to :entry
  belongs_to :user
  include ImageValidation
  include Recoverable
  has_one_attached :file
  validate_images :file
  encrypts :title, :description, deterministic: true

  
  # def as_json(args={})
  #   super(args.merge(
  #     only: [:id, :title, :description],
  #     methods: [:file_url],
  #   ))
  # end

  # def file_url
  #   Rails.application.routes.url_helpers.url_for(file)
  # end
end
