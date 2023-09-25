require 'rails_helper'

RSpec.describe "The actions dropdown", type: :system do
  describe "", :js do
    let(:user) { create :user }

    before do
      sign_in user
    end
    it "is on the person show page" do
      pending
      fail
    end
    it "is on the entry show page" do
      pending
      fail
    end
    it "shows options when clicked" do
      pending
      fail
    end
    it "has clickable options" do
      pending
      fail
    end
    describe "the edit option" do
      it "links to the edit show page" do
        pending
        fail
      end
    end
  end
end