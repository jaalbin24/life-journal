# == Schema Information
#
# Table name: people
#
#  id         :bigint           not null, primary key
#  age        :integer
#  first_name :string
#  last_name  :string
#  sex        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Person < ApplicationRecord
    def name
        [first_name, last_name].reject(&:blank?).join(" ")
    end
end
