class PagesController < ApplicationController
  before_action :redirect_unauthenticated
  
  def home
    @quote_of_the_day = Daily.quote
  end
end
