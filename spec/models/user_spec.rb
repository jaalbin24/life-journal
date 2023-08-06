# == Schema Information
#
# Table name: users
#
#  id              :uuid             not null, primary key
#  email           :string
#  password_digest :string
#  status          :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
require 'rails_helper'

RSpec.describe User, type: :model do
  describe "scopes" do
    it do
      pending
      fail
    end
  end

  describe "attributes" do
    it do
      pending
      fail
    end
  end

  describe "methods" do
    it do
      pending
      fail
    end
  end

  describe "callbacks" do
    it do
      pending
      fail
    end
  end

  describe "associations" do
    it do
      pending
      fail
    end
  end

  describe "validations" do
    it do
      pending
      fail
    end
  end
end
