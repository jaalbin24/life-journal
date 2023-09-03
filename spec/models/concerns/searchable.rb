RSpec.shared_examples Searchable, elasticsearch: true do |model_class|
  let(:model) { model_class.to_s.underscore.to_sym }

  before { @searchable_attrs = model_class.get_searchable_attrs } # Store the original serchable attributes so they can be reset later
  after { model_class.searches *@searchable_attrs }               # Reset the searchable attributes for the next test

  it "implements the Searchable concern" do
    expect(model_class.ancestors).to include Searchable
  end
  it "includes the necessary Elasticsearch modules" do
    expect(model_class.ancestors).to include Elasticsearch::Model
    expect(model_class.ancestors).to include Elasticsearch::Model::Callbacks
  end

  describe "methods" do
    # This concern currently doesn't implement any instance methods
  end

  describe "class methods" do
    describe "#search" do
      context "with type set to exact" do
        it "returns exact matches" do
          m = create model
          atty = model_class.get_searchable_attrs.first
          m.update(atty => "exactmatch")
          sleep 1 # Give time for the Elasticsearch background jobs to fire
          atty_value = m.send(atty)
          result = model_class.search("notanexactmatch", user: m.user).first
          expect(result).to_not eq(m), "If this fails, it might be due to the timing of the background API calls."
          result = model_class.search("exactmatch", user: m.user).first
          expect(result).to eq(m), "If this fails, it might be due to the timing of the background API calls."
        end
      end
      context "with no type passed" do
        it "defaults to autocomplete" do
          m = create model
          atty = model_class.get_searchable_attrs.first
          m.update(atty => "Abcdefghijklmnopqrstuvwxyz")
          sleep 1 # Give time for the Elasticsearch background jobs to fire
          atty_value = m.send(atty)
          result = model_class.search("Abcdefg", user: m.user).first
          expect(result).to eq(m), "If this fails, it might be due to the timing of the background API calls."
        end
      end
      context "with no user passed" do
        it "defaults to the current user" do
          u1 = create :user
          u2 = create :user
          Current.user = u1
          expect(Current).to receive(:user).and_return(u1)
          model_class.search
        end
      end
      context "with no page number passed" do
        it "defaults to page 1" do
          pending
          fail
          m = create model
          model_class.search
        end
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
        [:attribute1, :attribute2].each do |attribute|
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
    # This concern does not trigger any callbacks
  end
end