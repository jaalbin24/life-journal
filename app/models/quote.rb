# == Schema Information
#
# Table name: quotes
#
#  id          :uuid             not null, primary key
#  author      :string
#  content     :string
#  deleted     :boolean
#  deleted_at  :datetime
#  description :string
#  source      :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_quotes_on_deleted     (deleted)
#  index_quotes_on_deleted_at  (deleted_at)
#
class Quote < ApplicationRecord
end
