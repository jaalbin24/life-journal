require 'rails_helper'



RSpec.describe 'Editing an entry', type: :system do
  describe "", :js do
    # Used to test typing in the search field

    let(:user)            { create :user }
    let!(:entry)          { create :entry, user: user }

    before do
      sign_in user
      visit edit_entry_path(entry)
    end

    describe "the save bar" do
      context "after publish is clicked" do
        context "and the form submission succeeds" do
          describe "the message" do
            it "reads 'Published' for 3 seconds then reads 'Last updated at **:**'" do
              pending
              fail
            end
          end
        end
        context "and the form submission fails" do
          describe "the message" do
            it "reads 'Not published' for 3 seconds then reads 'Last updated at **:**'" do
              pending
              fail
            end
          end
        end
      end
      context "after unpublish is clicked" do
        context "and the form submission succeeds" do
          describe "the message" do
            it "reads 'Unpublished' for 3 seconds then reads 'Last updated at **:**'" do
              pending
              fail
            end
          end
        end
        context "and the form submission fails" do
          describe "the message" do
            it "reads 'Not unpublished' for 3 seconds then reads 'Last updated at **:**'" do
              pending
              fail
            end
          end
        end
      end
      context "after save is clicked" do
        context "and the form submission succeeds" do
          context "when the entry is published" do
            describe "the message" do
              it "reads 'Published' for 3 seconds then reads 'Last updated at **:**'" do
                pending
                fail
              end
            end
          end
          context "when the entry is not published" do
            describe "the message" do
              it "reads 'Saved' for 3 seconds then reads 'Last updated at **:**'" do
                pending
                fail
              end
            end
          end
        end
        context "and the form submission fails" do
          describe "the message" do
            it "reads 'Not saved' for 3 seconds then reads 'Last updated at **:**'" do
              pending
              fail
            end
          end
        end
      end
    end
  end
end