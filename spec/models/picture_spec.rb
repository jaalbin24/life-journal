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
#  index_pictures_on_deleted     (deleted)
#  index_pictures_on_deleted_at  (deleted_at)
#  index_pictures_on_entry_id    (entry_id)
#  index_pictures_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (entry_id => entries.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'
require 'models/concerns/image_validation'
require 'models/concerns/recoverable'

RSpec.describe Picture, type: :model do

  it_behaves_like ImageValidation,  Picture
  it_behaves_like Recoverable,      Picture

  describe "scopes" do
    # The picture model has no scopes
  end

  describe "attributes" do
    describe "#title" do
      it "is encrypted deterministically" do
        title = "The Test Title"
        p = create :picture, title: title
        expect(Picture.encrypted_attributes).to include :title
        # Models are only searchable on encrypted attributes when encrypted deterministically
        expect(Picture.find_by(title: title)).to eq p
      end
      it "preserves capitalization" do
        title = "The Test Title"
        p = create :picture, title: title
        expect(p.title).to eq title
      end
      it "returns a string" do
        p = create :picture, title: "Title"
        expect(p.title).to be_a String
      end
    end
    describe "#description" do
      it "is encrypted deterministically" do
        description = "The Test Description"
        p = create :picture, description: description
        expect(Picture.encrypted_attributes).to include :description
        # Models are only searchable on encrypted attributes when encrypted deterministically
        expect(Picture.find_by(description: description)).to eq p
      end
      it "preserves capitalization" do
        description = "The Test Description"
        p = create :picture, description: description
        expect(p.description).to eq description
      end
      it "returns a string" do
        p = create :picture, description: "Description"
        expect(p.description).to be_a String
      end
    end
    it "contains no unexpected attributes" do
      expected_attributes = [
        :id,
        :description,
        :title,
        :entry_id,
        :user_id,
        :deleted,
        :deleted_at,
        :created_at,
        :updated_at
      ]
      unexpected_attributes = Picture.new.attributes.keys.map(&:to_sym) - expected_attributes
      expect(unexpected_attributes).to be_empty, "Unexpected attributes found: #{unexpected_attributes.join(' ')}"
    end
  end

  describe "methods" do
    # The picture model has no methods to test
  end

  describe "callbacks" do
    # The picture model has no callbacks to test
  end

  describe "associations" do
    describe "#entry" do
      it "is required" do
        p = create :picture
        expect(p.valid?).to be true
        p.entry = nil
        expect(p.valid?).to be false
      end
      it "is a belongs_to relationship" do
        expect(Picture.reflect_on_association(:entry).macro).to eq(:belongs_to)
      end
      it "is not triggered to update when this model updates" do
        p = create :picture
        updated_at_before = p.entry.updated_at
        p.save
        expect(p.entry.updated_at).to eq updated_at_before
      end
    end
    describe "#user" do
      it "is required" do
        p = create :picture
        expect(p.valid?).to be true
        p.user = nil
        expect(p.valid?).to be false
      end
      it "is a belongs_to relationship" do
        expect(Picture.reflect_on_association(:user).macro).to eq(:belongs_to)
      end
      it "is not triggered to update when this model updates" do
        p = create :picture
        updated_at_before = p.user.updated_at
        p.save
        expect(p.user.updated_at).to eq updated_at_before
      end
    end
    describe "#file" do
      it "is a has_one_attached relationship" do
        expect(Picture.new.file).to be_an_instance_of(ActiveStorage::Attached::One)
      end
      it "is destroyed when the record is destroyed" do
        p = create :picture
        expect(p.file).to be_attached
        p.destroy
        expect(p.file.persisted?).to be false
      end
    end
  end

  describe "validations" do
    # The picture model has no validations to test
  end
end
