RSpec.shared_examples Searchable do |model_class|
  let(:model) { model_class.to_s.underscore.to_sym }

  it "implements the Searchable concern" do
    expect(model_class.ancestors).to include Searchable
  end
  it "includes the necessary Elasticsearch modules" do
    expect(model_class.ancestors).to include Elasticsearch::Model
    expect(model_class.ancestors).to include Elasticsearch::Model::Callbacks
  end

  describe "methods" do
    describe "#delete_es_document" do
      it "enqueues a DeleteElasticsearchDocumentJob job" do
        pending
        fail
      end
    end
    describe "#index_es_document" do
      it "enqueues an IndexElasticsearchDocumentJob job" do
        pending
        fail
      end
    end
    describe "#update_es_document" do
      it "enqueues an UpdateElasticsearchDocumentJob job" do
        pending
        fail
      end
    end
  end

  describe "class methods" do
    describe "#search" do
      it "returns exact matches" do
        pending
        fail
      end
      it "searches on all defined searchable attributes" do
        pending
        fail
      end
    end
    describe "#searches" do
      it "sets @searchable_attrs" do
        pending
        fail
      end
      it "sets defines the elasticsearch indexes" do
        pending
        fail
      end
    end
    describe "#get_searchable_attrs" do
      it "is private" do
        pending
        fail
      end
    end
    describe "rebuild_elasticsearch_index" do
      it "raises an error if run in a production environment" do
        pending
        fail
      end
    end
  end

  describe "callbacks" do
    describe "after_commit" do
      context "on create" do
        it "calls the #index_es_document method" do
          m = build model
          expect(m).to receive(:index_es_document)
          m.save
        end
        it "does not call the #update_es_document method" do
          m = build model
          expect(m).to_not receive(:update_es_document)
          m.save
        end
        it "does not call the #delete_es_document method" do
          m = build model
          expect(m).to_not receive(:delete_es_document)
          m.save
        end
      end
      context "on update" do
        it "calls the #update_es_document method" do
          m = create model
          expect(m).to receive(:update_es_document)
          m.save
        end
        it "does not call the #index_es_document method" do
          m = create model
          expect(m).to_not receive(:index_es_document)
          m.save
        end
        it "does not call the #delete_es_document method" do
          m = create model
          expect(m).to_not receive(:delete_es_document)
          m.save
        end
      end
      context "on destroy" do
        it "calls the #delete_es_document method" do
          m = create model
          expect(m).to receive(:delete_es_document)
          m.destroy
        end
        it "does not call the #index_es_document method" do
          m = create model
          expect(m).to_not receive(:index_es_document)
          m.destroy
        end
        it "does not call the #update_es_document method" do
          m = create model
          expect(m).to_not receive(:update_es_document)
          m.destroy
        end
      end
    end
  end
end