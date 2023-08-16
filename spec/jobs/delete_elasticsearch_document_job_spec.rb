require 'rails_helper'

# Testing with the Person model
RSpec.describe DeleteElasticsearchDocumentJob, type: :job do
  it "calls #delete_document on the models __elasticsearch__ object" do
    p = create :person
    elasticsearch_proxy = double("__elasticsearch__")
    allow(p).to receive(:__elasticsearch__).and_return(elasticsearch_proxy)
    allow(elasticsearch_proxy).to receive(:delete_document)
    DeleteElasticsearchDocumentJob.perform_now(p)
    expect(elasticsearch_proxy).to have_received(:delete_document), "__elasticsearch__.delete_document was not called"
  end
  it "implements the NetJob concern" do
    expect(DeleteElasticsearchDocumentJob.ancestors).to include NetJob
  end
end
