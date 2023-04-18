RSpec.describe "Creating a person", type: :system do
    context "without any details" do
        it "will show a flash alert message" do
            sign_in
            visit new_person_path
            test_id('save_person_button').click
            expect(page).to have_text "There was an error creating that person."
        end
        it "will not create a person" do
            pending "Test can be written"
            fail
        end
    end
    it "will show a flash success message" do
        pending "Test can be written"
        fail
    end
    it "will create a person" do
        pending "Test can be written"
        fail
    end
    it "will show the new person page" do
        pending "Test can be written"
        fail
    end
end