# This concern makes it so models can be "summarized" with
# the #summary method. It's similar to #to_s but it's not great
# paractice to override such a fundamental method

module Summarizable
  extend ActiveSupport::Concern

  included do
    # This method is meant to be overridden
    def summarize
      id
    end
  end  
end