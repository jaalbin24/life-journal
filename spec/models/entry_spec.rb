require 'rails_helper'

RSpec.describe Entry, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"

  describe "scopes" do
    describe "#empty" do
        it "selects entries without a title" do
            create :entry, title: nil
        end
        it "selects entries without text_content" do
            create :entry, text_content: nil
        end
        it "selects entries without mentions" do
            create :entry, mentions: nil
        end
    end

  end




  



end


