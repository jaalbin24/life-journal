require 'rails_helper'

RSpec.describe IndexElasticsearchDocumentJob, type: :job do
  it "calls #delete_document on the models __elasticsearch__ object" do
    p = create :person
    elasticsearch_proxy = double("__elasticsearch__")
    allow(p).to receive(:__elasticsearch__).and_return(elasticsearch_proxy)
    allow(elasticsearch_proxy).to receive(:index_document)
    IndexElasticsearchDocumentJob.perform_now(p)
    expect(elasticsearch_proxy).to have_received(:index_document), "__elasticsearch__.index_document was not called"
  end
  it "implements the NetJob concern" do
    expect(IndexElasticsearchDocumentJob.ancestors).to include NetJob
  end
end
