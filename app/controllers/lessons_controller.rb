class LessonsController < ApplicationController
  before_action :redirect_unauthenticated

  # GET /lessons
  def index

  end

  # PUT/PATH /lessons/:lesson_id
  def update

  end

  # GET /lessons/new
  def new
    @lesson = current_user.lessons.build(
      person_id: params[:taught_by]
    )
  end

  # POST /lessons
  def create

  end

  # GET /lessons/:lesson_id
  def show

  end

  # DELETE /lessons/:lesson_id
  def destroy

  end

  private

  def lesson_params
    params.require(:lesson).permit(
      :content,
      mentions_attributes: [
        :id,
        :person_id,
        :_destroy
      ]
    )
  end
end
