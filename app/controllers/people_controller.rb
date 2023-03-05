class PeopleController < ApplicationController
  before_action :set_person, only: %i[ show edit update destroy ]
  before_action :redirect_unauthenticated

  def search
    people = current_user.people.search(search_params).first(10)
    render json: people
  end

  def show
    
  end


  private

  def search_params
    params.require(:person).permit(
      :name
    )
  end

  def set_person
    @person = Person.find(params[:id])
  end
end
