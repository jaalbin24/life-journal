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
  end
  
  class_methods do
    def search(keyword='', page: 1, user: Current.user, type: :autocomplete)
      page ||= 1
      type ||= :autocomplete
      user ||= Current.user
      if type.to_sym == :autocomplete
        must = {
          multi_match: {
            query: keyword,
            type: 'bool_prefix',
            fields: get_searchable_attrs
          }
        }
      else
        must = { 
          multi_match: {
            query: keyword,
            fields: get_searchable_attrs
          }
        }
      end

      if ['*', ''].include? keyword
        query = { match_all: {} }
      else
        query = {
          bool: {
            must: [
              must,
            {
              match: {
                user_id: user.id
              }
            }]
          }
        }
      end
      __elasticsearch__.search({
        query: query,
        size: default_per_page,
        from: (page.to_i - 1) * default_per_page
      }).records
    end
    

    # Defines the attributes that can be used to search in the model.
    # Also inits elasticsearch settings.
    # Set searchable_attrs in the model file.
    def searches(*searchable_attrs)
      raise StandardError.new "searches must take an argument" unless searchable_attrs
      settings index: { number_of_shards: 1, number_of_replicas: 0 }
      
      mappings dynamic: false do
        indexes :user_id, type: 'keyword'
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
      begin
        self.__elasticsearch__.delete_index! # VERY LAGGY
      rescue
        # Do nothing. There was no index to delete.
      end
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