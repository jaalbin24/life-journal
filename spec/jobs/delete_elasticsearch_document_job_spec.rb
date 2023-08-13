require 'rails_helper'

RSpec.describe DeleteElasticsearchDocumentJob, type: :job do
  pending "add some examples to (or delete) #{__FILE__}"
  context "after failing due to a network error" do
    it "tries again using an exponential backoff strategy" do

    end
  end
end
