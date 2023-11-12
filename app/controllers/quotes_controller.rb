class QuotesController < ApplicationController
  before_action :redirect_unauthenticated
  before_action :set_quote, only: :show

  def show
    respond_to do |format|
      format.html { render :show }
    end
  end

  private

  def set_quote
    @quote = Quote.find(params[:id])
  end
end
