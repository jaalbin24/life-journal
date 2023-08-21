
# This concern makes models searchable via Elasticsearch.
#
# To implement this concern, do the following in your model:
#   1) Include the concern (duh)
#   2) Define the attributes that your model should be searched on using the #searches method
#   3) Define the number of records on each returned search page using paginates_per
#       - Side note: To implement this concern, you need to also use the Kaminari gem.
#   4) Start searching using Class.search("keyword")

module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    after_commit :index_es_document,    on: [:create]
    after_commit :update_es_document,   on: [:update]
    after_commit :delete_es_document,   on: [:destroy]

    def index_es_document
      IndexElasticsearchDocumentJob.perform_later self
    end

    def update_es_document
      UpdateElasticsearchDocumentJob.perform_later self
    end

    def delete_es_document
      DeleteElasticsearchDocumentJob.perform_later self
    end
  end
  
  class_methods do
    def search(query, opts={page: 1})
      __elasticsearch__.search(
        {
          query: {
            multi_match: {
              query: query,
              fields: get_searchable_attrs,
              fuzziness: 'AUTO'
            }
          },
          size: 200
        }
      ).records
    end

    # Defines the attributes that can be used to search in the model.
    # Also inits elasticsearch settings.
    # Set searchable_attrs in the model file.
    def searches(*searchable_attrs)
      raise StandardError.new "searches must take an argument" unless searchable_attrs
      settings index: { number_of_shards: 1, number_of_replicas: 0 }
      
      mappings dynamic: false do
        searchable_attrs.each do |atty|
          indexes atty, type: 'text'
        end
      end
      @searchable_attrs = searchable_attrs.map(&:to_sym)
    end

    # WARNING CAUTION DANGER CAREFUL WATCH OUT
    # For development/testing purposes ONLY
    def rebuild_elasticsearch_index
      raise StandardError.new "DO NOT RUN THIS METHOD IN PRODUCTION" if Rails.env.production?
      self.__elasticsearch__.delete_index! # VERY LAGGY
      sleep 1
      self.__elasticsearch__.create_index! # VERY LAGGY
      sleep 1
      self.import
    end
    # End of danger


    def get_searchable_attrs
      raise StandardError.new "searchable_attrs are not defined for the #{self.name} class." unless @searchable_attrs
      @searchable_attrs
    end
  end
end