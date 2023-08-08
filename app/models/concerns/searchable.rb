
# This concern makes models searchable by specified attributes.
# a user "deletes" them. 
#
# To implement this concern, the model needs the following attributes
#   - boolean:  deleted
#   - datetime: deleted_at

module Searchable
  extend ActiveSupport::Concern



  included do
    include Elasticsearch::Model 
    include Elasticsearch::Model::Callbacks

    settings index: { number_of_shards: 1, number_of_replicas: 0 } do
      mappings dynamic: 'false' do
        indexes :first_name, type: 'text'
        indexes :last_name, type: 'text'
      end
    end
  end
  

  class_methods do
    def search(query)
      __elasticsearch__.search(
        {
          query: {
            multi_match: {
              query: query,
              fields: get_search_fields
            }
          }
        }
      )
    end

    # Defines the attributes that can be used to search in the model.
    def search_on(*search_fields)
      raise StandardError.new "search_on must take an argument" unless search_fields
      @@search_fields ||= search_fields.map(&:to_s)
    end

    def start
      Person.__elasticsearch__.delete_index!
      sleep 1
      Person.__elasticsearch__.create_index!
      sleep 1
      Person.import
    end

    private

    def get_search_fields
      raise StandardError.new "search_fields are not defined for the #{self.name} class." unless @@search_fields
      @@search_fields 
    end
  end
end