require 'rails_helper'

# This concern is tested using the Person model

RSpec.describe Searchable, type: :model do
    it "is a concern" do
        expect(Searchable.ancestors).to include ActiveSupport::Concern
    end

    describe "scopes" do
        # This concern does not implement any scopes
    end
    describe "callbacks" do
        describe "after_commit on create" do
            it "calls the index_es_document method" do
                p = build :person
                expect(p).to receive :index_es_document
                p.save
            end
            it "does not call the update_es_document method" do
                p = build :person
                expect(p).to_not receive :update_es_document
                p.save
            end
            it "does not call the delete_es_document method" do
                p = build :person
                expect(p).to_not receive :delete_es_document
                p.save
            end
        end
        describe "after_commit on update" do
            it "does not call the index_es_document method" do
                p = create :person
                expect(p).to_not receive :index_es_document
                p.update(first_name: "Tester")
            end
            it "calls the update_es_document method" do
                p = create :person
                expect(p).to receive :update_es_document
                p.update(first_name: "Tester")
            end
            it "does not call the delete_es_document method" do
                p = create :person
                expect(p).to_not receive :delete_es_document
                p.update(first_name: "Tester")
            end
        end
        describe "after_commit on destroy" do
            it "does not call the index_es_document method" do
                p = create :person
                expect(p).to_not receive :index_es_document
                p.destroy
            end
            it "calls the update_es_document method" do
                p = create :person
                expect(p).to_not receive :update_es_document
                p.destroy
            end
            it "calls the delete_es_document method" do
                p = create :person
                expect(p).to receive :delete_es_document
                p.destroy
            end
        end
    end
    describe "methods" do
        describe "#index_es_document" do
            it "enqueues an IndexElasticsearchDocumentJob job" do
                p = create :person
                expect { p.index_es_document }.to have_enqueued_job IndexElasticsearchDocumentJob
            end
        end
        describe "#update_es_document" do
            it "enqueues an UpdateElasticsearchDocumentJob job" do
                p = create :person
                expect { p.update_es_document }.to have_enqueued_job UpdateElasticsearchDocumentJob
            end
        end
        describe "#delete_es_document" do
            it "enqueues a DeleteElasticsearchDocumentJob job" do
                p = create :person
                expect { p.delete_es_document }.to have_enqueued_job DeleteElasticsearchDocumentJob
            end
        end
        describe "#searches" do
            it "defines the attributes that the model can be searched on" do
                pending "How do you test this?"
                fail
            end
        end
        describe "#rebuild_elasticsearch_index" do
            context "in a production environment" do
                before do
                    allow(Rails).to receive(:env).and_return(ActiveSupport::StringInquirer.new("production"))
                end
          
                it "raises an error" do
                    p = create :person
                    expect { p.rebuild_elasticsearch_index }.to raise_error StandardError
                end
            end
        end
        describe "#search" do
            it "searches the model" do
                pending "You need to decide what search functionality you want in the app."
                fail
            end
        end
    end
end