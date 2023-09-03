require 'rails_helper'



RSpec.describe 'Mentions', type: :system do
  describe "", :js do
    # Used to test typing in the search field
    let(:user)            { create :user }
    let!(:bartholomew)    { create :person, user: user, first_name: "Bartholomew" }
    let!(:barabbas)       { create :person, user: user, first_name: "Barabbas" }
    let!(:peter)          { create :person, user: user, first_name: "Peter" }
    let!(:mary)           { create :person, user: user, first_name: "Mary" }
    let!(:entry)          { create :entry, user: user }
    let!(:mentioned_mary) { create :mention, entry: entry, person: mary, user: user }
    let(:mentions)        { find(test_id("mentions-turbo-frame")) }
    let(:search_bar)      { find("#mentions-search") }      



    before do
      sign_in user
      visit edit_entry_path(entry)
    end

    describe "searching for a person to mention" do
      context "when the entry is not persisted" do
        it "is not permited" do
          visit new_entry_path
          expect(page).to have_content "Save your entry before adding mentions."
        end
      end
      context "when the entry is persisted" do
        describe "Search functionality" do
          let(:start_typing)  { "Start typing to search" }
          it "searches and narrows down results as the user types" do
            fill_and_check(search_bar, with: "b", present: ["Bartholomew", "Barabbas"], absent: ["Peter"])
            fill_and_check(search_bar, with: "ba", present: ["Bartholomew", "Barabbas"], absent: ["Peter"])
            fill_and_check(search_bar, with: "bar", present: ["Bartholomew", "Barabbas"], absent: ["Peter"])
            fill_and_check(search_bar, with: "bart", present: ["Bartholomew"], absent: ["Barabbas", "Peter"])
          end

          it "shows the default message before the user starts typing and when the user deletes their input" do
            try_it_twice do
              expect(page).to_not have_content start_typing
              search_bar.set search_bar.value # Focus on the search field
              expect(page).to have_content start_typing
              fill_and_check(search_bar, with: "", present: [start_typing])
              fill_and_check(search_bar, with: "q", absent: [start_typing])
              fill_and_check(search_bar, with: "", present: [start_typing])
            end
          end

          it "shows the default message when hovering over the search field" do
            try_it_twice do
              expect(page).to_not have_content start_typing
              search_bar.set("")
              mentions.click # Reset the cursor
              search_bar.hover
              expect(page).to have_content start_typing
            end
          end

          it "shows a message when there are no results" do
            try_it_twice do
              expect(page).to_not have_content start_typing
              search_keyword = "qwerty"
              fill_and_check(search_bar, with: search_keyword, present: ["No results for #{search_keyword}"])
              fill_and_check(search_bar, with: "", present: [start_typing])
            end
          end
        end
      end
    end
    describe "adding a mention" do
      let(:add_bartholomew) { find(test_id("add-mention-#{bartholomew.id}")) }
      it "happens when the user clicks on a person in the search results dropdown" do
        try_it_twice do
          expect(mentions).to_not have_content "Bartholomew"
          fill_and_check search_bar, with: "Bartholomew"
          add_bartholomew.click
          expect(mentions).to have_content "Bartholomew"
        end
      end
    end
    describe "deleting a mention" do
      let(:mention_x_el)    { find(test_id("destroy-mention-#{mentioned_mary.id}")) }
      let(:mention_el)      { find(test_id("mention-#{mentioned_mary.id}")) }
      it "happens when the user clicks the X button next to a mention" do
        try_it_twice do
          expect(mentions).to have_content "Mary"
          mention_el.hover
          mention_x_el.click
          expect(mentions).to_not have_content "Mary"
        end
      end
    end
    context "when the entry has no mentions" do
      let(:empty_mention_message) { "No one is mentioned in this entry. Start typing or search for someone to mention." }
      it "shows a message to the user in the mentions collection turbo frame" do
        try_it_twice do
          mentioned_mary.destroy # To clear out the mentions
          refresh
          expect(mentions).to have_content empty_mention_message + ""
        end
      end
    end
  end
end