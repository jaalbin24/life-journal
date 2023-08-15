require 'rails_helper'

# Testing with the Person model
RSpec.describe DeleteElasticsearchDocumentJob, type: :job do
  pending "add some examples to (or delete) #{__FILE__}"
  it "takes an ActiveRecord model object as an argument" do
    p = create :person
    expect(p).to receive(:__elasticsearch__)#.and_return(double(delete_document: true))
    DeleteElasticsearchDocumentJob.perform_now
  end
  it "calls #delete_document on the models __elasticsearch__ object" do

  end
  it "implements the NetJob concern" do
    expect(DeleteElasticsearchDocumentJob.ancestors).to include NetJob
  end
end
