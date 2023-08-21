RSpec.shared_examples Searchable, elasticsearch: true do |model_class|
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
        m = create model
        expect { m.delete_es_document }.to have_enqueued_job DeleteElasticsearchDocumentJob
      end
    end
    describe "#index_es_document" do
      it "enqueues an IndexElasticsearchDocumentJob job" do
        m = create model
        expect { m.index_es_document }.to have_enqueued_job IndexElasticsearchDocumentJob
      end
    end
    describe "#update_es_document" do
      it "enqueues an UpdateElasticsearchDocumentJob job" do
        m = create model
        expect { m.update_es_document }.to have_enqueued_job UpdateElasticsearchDocumentJob
      end
    end
  end

  describe "class methods" do
    describe "#search" do
      it "takes"
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
        expect(model_class.get_searchable_attrs).to_not include :id
        model_class.searches :id
        expect(model_class.get_searchable_attrs).to include :id
      end

      it "defines the elasticsearch indexes" do
        # Here we define some arbitrary attributes
        model_class.searches :attribute1, :attribute2

        # We push these new attributes to the elasticsearch server
        model_class.__elasticsearch__.create_index! force: true

        # Then we verify that the attributes have corresponding indexes
        mappings = Elasticsearch::Model.client.indices.get_mapping(index: Person.index_name)
        model_class.get_searchable_attrs.each do |attribute|
          attribute_mapping = mappings.dig(model_class.index_name, 'mappings', 'properties', attribute.to_s)
          expect(attribute_mapping).not_to be_nil, "mapping for #{attribute} is nil"
          expect(attribute_mapping['type']).to eq('text')
        end
      end
    end
    describe "#get_searchable_attrs" do
      it "returns an array of the searchable attributes" do
        model_class.searches :id
        expect(model_class.get_searchable_attrs).to be_an Array
        expect(model_class.get_searchable_attrs).to include :id
        expect(model_class.get_searchable_attrs.size).to eq 1
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