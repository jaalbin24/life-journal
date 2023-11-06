# == Schema Information
#
# Table name: chats
#
#  id         :uuid             not null, primary key
#  status     :string
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  entry_id   :uuid             not null
#  user_id    :uuid             not null
#
# Indexes
#
#  index_chats_on_entry_id  (entry_id)
#  index_chats_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (entry_id => entries.id)
#  fk_rails_...  (user_id => users.id)
#
class Chat < ApplicationRecord
  belongs_to :entry
  belongs_to :user
  has_many :messages, dependent: :destroy
  accepts_nested_attributes_for :messages, allow_destroy: true

  before_validation :set_user, on: :create
  
  private

  def set_user
    self.user = entry.user
  end
end
