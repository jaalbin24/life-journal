require 'rails_helper'

RSpec.describe UpdateElasticsearchDocumentJob, type: :job do
  it "calls #delete_document on the models __elasticsearch__ object" do
    p = create :person
    elasticsearch_proxy = double("__elasticsearch__")
    allow(p).to receive(:__elasticsearch__).and_return(elasticsearch_proxy)
    allow(elasticsearch_proxy).to receive(:update_document)
    UpdateElasticsearchDocumentJob.perform_now(p)
    expect(elasticsearch_proxy).to have_received(:update_document), "__elasticsearch__.update_document was not called"
  end
  it "implements the NetJob concern" do
    expect(UpdateElasticsearchDocumentJob.ancestors).to include NetJob
  end
end
