require 'rails_helper'



RSpec.describe 'Mentions', type: :system do
  describe "", :js do
    # Used to test typing in the search field
    def fill_and_check(input, expectations={ present: [], absent: [] })
      try_it_twice do
        aggregate_failures do
          fill_in "mentions-search", with: input
          expectations[:present]&.each { |content| expect(page).to have_content content }
          expectations[:absent]&.each { |content| expect(page).to_not have_content content }
        end
      end
    end
    let(:user)            { create :user }
    let!(:bartholomew)    { create :person, user: user, first_name: "Bartholomew" }
    let!(:barabbas)       { create :person, user: user, first_name: "Barabbas" }
    let!(:peter)          { create :person, user: user, first_name: "Peter" }
    let!(:mary)           { create :person, user: user, first_name: "Mary" }
    let!(:entry)          { create :entry, user: user }
    let!(:mentioned_mary) { create :mention, entry: entry, person: mary, user: user }
    let(:mentions)        { find(test_id("mentions-turbo-frame")) }


    before do
      sign_in user
      visit edit_entry_path(entry)
    end

    describe "searching for a person to mention" do
      context "when the entry is not persisted" do
        it "is not permited" do
          visit new_entry_path
          expect(page).to have_content "Save this entry to add mentions and pictures."
        end
      end
      context "when the entry is persisted" do
        describe "Search functionality" do
          let(:start_typing)  { "Start typing to search" }
          let(:search_bar)    { find("#mentions-search") }      
          it "searches and narrows down results as the user types" do
            fill_and_check("b", present: ["Bartholomew", "Barabbas"], absent: ["Peter"])
            fill_and_check("ba", present: ["Bartholomew", "Barabbas"], absent: ["Peter"])
            fill_and_check("bar", present: ["Bartholomew", "Barabbas"], absent: ["Peter"])
            fill_and_check("bart", present: ["Bartholomew"], absent: ["Barabbas", "Peter"])
          end

          it "shows the default message before the user starts typing and when the user deletes their input" do
            try_it_twice do
              expect(page).to_not have_content start_typing
              search_bar.set search_bar.value # Focus on the search field
              expect(page).to have_content start_typing
              fill_and_check("", present: [start_typing])
              fill_and_check("q", absent: [start_typing])
              fill_and_check("", present: [start_typing])
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
              fill_and_check(search_keyword, present: ["No results for #{search_keyword}"])
              fill_and_check("", present: [start_typing])
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
          fill_and_check "Bartholomew"
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
  end
end