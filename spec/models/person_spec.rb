# == Schema Information
#
# Table name: people
#
#  id          :uuid             not null, primary key
#  biography   :string
#  deleted     :boolean
#  deleted_at  :datetime
#  first_name  :string
#  gender      :string
#  last_name   :string
#  middle_name :string
#  nickname    :string
#  notes       :string
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :uuid
#
# Indexes
#
#  index_people_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'
require 'models/concerns/image_validation'

RSpec.describe Person, type: :model do
  describe "scopes" do
    # There are currently no scopes in the Person model
  end

  it "implements the Searchable concern" do
    expect(Person.ancestors).to include Searchable
  end
  it_behaves_like Recoverable,      Person
  it_behaves_like ImageValidation,  Person


  describe "ElasticSearch" do
    it "is included" do
      expect(Person.ancestors).to include Elasticsearch::Model
      expect(Person.ancestors).to include Elasticsearch::Model::Callbacks
    end
    it "indexes on the person's first name" do
      pending "How do I test this?"
      fail
    end
    it "indexes on the person's middle name" do
      pending "How do I test this?"
      fail
    end
    it "indexes on the person's last name" do
      pending "How do I test this?"
      fail
    end
    it "indexes on the person's nickname" do
      pending "How do I test this?"
      fail
    end
  end

  describe "attributes" do
    describe "#first_name" do
      it "is encrypted" do
        expect(Person.encrypted_attributes).to include :first_name
      end
      it "returns a string" do
        p = create :person, first_name: "John"
        expect(p.first_name).to be_a String
      end
    end
    describe "#last_name" do
      it "is encrypted" do
        expect(Person.encrypted_attributes).to include :last_name
      end
      it "returns a string" do
        p = create :person, last_name: "Smith"
        expect(p.last_name).to be_a String
      end
    end
    describe "#middle_name" do
      it "is encrypted" do
        expect(Person.encrypted_attributes).to include :middle_name
      end
      it "returns a string" do
        p = create :person, middle_name: "Evans"
        expect(p.middle_name).to be_a String
      end
    end
    describe "#gender" do
      it "is encrypted" do
        expect(Person.encrypted_attributes).to include :gender
      end
      it "returns a string" do
        p = create :person, gender: "Male"
        expect(p.gender).to be_a String
      end
    end
    describe "#nickname" do
      it "is encrypted" do
        expect(Person.encrypted_attributes).to include :nickname
      end
      it "returns a string" do
        p = create :person, nickname: "Johnny Boy"
        expect(p.nickname).to be_a String
      end
    end
    describe "#title" do
      it "is encrypted" do
        expect(Person.encrypted_attributes).to include :title
      end
      it "returns a string" do
        p = create :person, title: "Captain"
        expect(p.title).to be_a String
      end
    end
    describe "#biography" do
      it "is encrypted non-deterministically" do
        expect(Person.encrypted_attributes).to include :biography
        people = Array.new(2) { create :person, biography: "The ciphertext should be different" }
        expect(people[0].ciphertext_for(:biography)).to_not eq people[1].ciphertext_for(:biography)
      end
      it "returns a string" do
        p = create :person, biography: "All about me"
        expect(p.biography).to be_a String
      end
    end
    it "contains no unexpected attributes" do
      expected_attributes = [
        :id,
        :title,
        :first_name,
        :middle_name,
        :last_name,
        :nickname,
        :gender,
        :biography,
        :notes,
        :deleted,
        :deleted_at,
        :user_id,
        :created_at,
        :updated_at
      ]
      unexpected_attributes = Person.new.attributes.keys.map(&:to_sym) - expected_attributes
      expect(unexpected_attributes).to be_empty, "Unexpected attributes found: #{unexpected_attributes.join(' ')}"
    end
  end

  describe "methods" do
    describe "#name" do
      it "returns a titleized string" do
        p = build :person, first_name: "john", last_name: "smith"
        expect(p.name).to eq "John Smith"
      end
      context "with a nickname" do
        context "with a first name" do
          context "with a last name" do
            it "returns the nickname and last name" do
              p = build :person, nickname: "Johnny", first_name: "John", last_name: "Smith"
              expect(p.name).to eq "Johnny Smith"
            end
          end
          context "without a last name" do
            it "returns the nickname" do
              p = build :person, nickname: "Johnny", first_name: "John", last_name: nil
              expect(p.name).to eq "Johnny"
            end
          end
        end
        context "without a first name" do
          context "with a last name" do
            it "returns the nickname and last name" do
              p = build :person, nickname: "Johnny", first_name: nil, last_name: "Smith"
              expect(p.name).to eq "Johnny Smith"
            end
          end
          context "without a last name" do
            it "returns the nickname" do
              p = build :person, nickname: "Johnny", first_name: nil, last_name: nil
              expect(p.name).to eq "Johnny"
            end
          end
        end
      end
      context "without a nickname" do
        context "with a first name" do
          context "with a last name" do
            it "returns the first name and last name" do
              p = build :person, nickname: nil, first_name: "John", last_name: "Smith"
              expect(p.name).to eq "John Smith"
            end
          end
          context "without a last name" do
            it "returns the first name" do
              p = build :person, nickname: nil, first_name: "John", last_name: nil
              expect(p.name).to eq "John"
            end
          end
        end
        context "without a first name" do
          context "with a last name" do
            it "returns the last name" do
              p = build :person, nickname: nil, first_name: nil, last_name: "Smith"
              expect(p.name).to eq "Smith"
            end
          end
          context "without a last name" do
            it "returns nil" do
              p = build :person, nickname: nil, first_name: nil, last_name: nil
              expect(p.name.blank?).to be true
            end
          end
        end
      end
    end
    describe "#full_name" do
      context "with a title" do
        context "with a first name" do
          context "with a middle name" do
            context "with a last name" do
              it "will return title first middle last" do
                p = build :person, title: "CEO", first_name: "John", middle_name: "Evans", last_name: "Smith"
                expect(p.full_name).to eq "CEO John Evans Smith"
              end
            end
            context "without a last name" do
              it "will return title first middle" do
                p = build :person, title: "CEO", first_name: "John", middle_name: "Evans"
                expect(p.full_name).to eq "CEO John Evans"
              end
            end
          end
          context "without a middle name" do
            context "with a last name" do
              it "will return title first last" do
                p = build :person, title: "CEO", first_name: "John", last_name: "Smith"
                expect(p.full_name).to eq "CEO John Smith"
              end
            end
            context "without a last name" do
              it "will return title first" do
                p = build :person, title: "CEO", first_name: "John"
                expect(p.full_name).to eq "CEO John"
              end
            end
          end
        end
        context "without a first name" do
          context "with a middle name" do
            context "with a last name" do
              it "will return title middle last" do
                p = build :person, title: "CEO", first_name: nil, middle_name: "Evans", last_name: "Smith"
                expect(p.full_name).to eq "CEO Evans Smith"
              end
            end
            context "without a last name" do
              it "will return title middle" do
                p = build :person, title: "CEO", first_name: nil, middle_name: "Evans"
                expect(p.full_name).to eq "CEO Evans"
              end
            end
          end
          context "without a middle name" do
            context "with a last name" do
              it "will return title last" do
                p = build :person, title: "CEO", first_name: nil, last_name: "Smith"
                expect(p.full_name).to eq "CEO Smith"
              end
            end
            context "without a last name" do
              it "will return title" do
                p = build :person, title: "CEO", first_name: nil
                expect(p.full_name).to eq "CEO"
              end
            end
          end
        end
      end
      context "without a title" do
        context "with a first name" do
          context "with a middle name" do
            context "with a last name" do
              it "will return first middle last" do
                p = build :person, first_name: "John", middle_name: "Evans", last_name: "Smith"
                expect(p.full_name).to eq "John Evans Smith"
              end
            end
            context "without a last name" do
              it "will return first middle" do
                p = build :person, first_name: "John", middle_name: "Evans"
                expect(p.full_name).to eq "John Evans"
              end
            end
          end
          context "without a middle name" do
            context "with a last name" do
              it "will return first last" do
                p = build :person, first_name: "John", last_name: "Smith"
                expect(p.full_name).to eq "John Smith"
              end
            end
            context "without a last name" do
              it "will return first" do
                p = build :person, first_name: "John"
                expect(p.full_name).to eq "John"
              end
            end
          end
        end
        context "without a first name" do
          context "with a middle name" do
            context "with a last name" do
              it "will return middle last" do
                p = build :person, middle_name: "Evans", last_name: "Smith", first_name: nil
                expect(p.full_name).to eq "Evans Smith"
              end
            end
            context "without a last name" do
              it "will return title middle" do
                p = build :person, middle_name: "Evans", first_name: nil
                expect(p.full_name).to eq "Evans"
              end
            end
          end
          context "without a middle name" do
            context "with a last name" do
              it "will return title last" do
                p = build :person, last_name: "Smith", first_name: nil
                expect(p.full_name).to eq "Smith"
              end
            end
            context "without a last name" do
              it "will be blank" do
                p = build :person, first_name: nil
                expect(p.full_name.blank?).to eq true
              end
            end
          end
        end
      end
    end
  end

  describe "callbacks" do
    # This model has no callbacks
  end

  describe "associations" do
    describe "#user" do
      it "returns the user object related to this person" do
        u = create :user
        p = u.people.create(attributes_for(:person))
        expect(p.user).to eq u
      end
      it "does not accept nested attributes" do
        expect { Person.new(user_attributes: []) }.to raise_error ActiveModel::UnknownAttributeError
      end
      it "is required to save the person" do
        p = build :entry, user: nil
        expect(p.valid?).to be false
        expect(p.save).to be false
        p.user = create :user
        expect(p.valid?).to be true
        expect(p.save).to be true
      end
      it "is not deleted when the person is deleted" do
        p = create :person
        u_id = p.user.id
        expect(Person.exists? p.id).to be true
        expect(p.destroy).to be_truthy
        expect(Person.exists? p.id).to be false
        expect(User.exists? u_id).to be true
      end
    end
  end

  describe "validations" do
    describe "name" do
      it "must be present" do
        p = create :person
        expect(p.name).to_not be_blank
        expect(p.valid?).to be true        
        p.first_name = nil
        expect(p.name).to be_blank
        expect(p.valid?).to be false       
      end
    end
    describe "avatar" do
      # All these tests should be moved to a dedicated ImageValidation test file
      # ======================== BEGIN ========================
      it "can be a png" do
        p = create :person
        image_path = Dir.glob("#{Rails.root.join('db', 'seed_data', 'avatars')}/*.png").sample        
        expect(image_path).to be_truthy # The file should exist
        p.avatar.attach(Rack::Test::UploadedFile.new(image_path))
        expect(p.valid?).to be true
      end
      it "can be a jpg" do
        p = create :person
        image_path = Dir.glob("#{Rails.root.join('db', 'seed_data', 'avatars')}/*.jpg").sample        
        expect(image_path).to be_truthy # The file should exist
        p.avatar.attach(Rack::Test::UploadedFile.new(image_path))
        expect(p.valid?).to be true
      end
      it "can be a jpeg" do
        p = create :person
        image_path = Dir.glob("#{Rails.root.join('db', 'seed_data', 'avatars')}/*.jpeg").sample        
        expect(image_path).to be_truthy # The file should exist
        p.avatar.attach(Rack::Test::UploadedFile.new(image_path))
        expect(p.valid?).to be true
      end
      it "cannot be any other file type" do
        pending "Download a file of every magic number and test that it cannot be attached."
        fail
      end
      # ========================= END =========================
    end
  end
end
