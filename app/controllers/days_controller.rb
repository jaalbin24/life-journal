class DaysController < ApplicationController
  before_action :redirect_unauthenticated

  # GET /days/:day
  def show
    @day = Date.parse("#{params[:day]}-#{params[:month]}-#{params[:year]}")
    @entries = current_user.entries.published.where(published_at: @day.beginning_of_day..@day.end_of_day)
    @people = current_user.people.where(created_at: @day.beginning_of_day..@day.end_of_day)
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(:day, partial: "show")
      end
      format.html do
        render :show
      end
    end
  end
end
