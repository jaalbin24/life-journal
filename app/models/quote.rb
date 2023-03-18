# == Schema Information
#
# Table name: quotes
#
#  id         :uuid             not null, primary key
#  author     :string
#  body       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Quote < ApplicationRecord
end
