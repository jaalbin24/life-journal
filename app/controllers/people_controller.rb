class PeopleController < ApplicationController
  before_action :redirect_unauthenticated
  before_action :set_person, only: %i[ show edit update destroy ]

  def search
    people = current_user.people.search(search_params).first(10)
    render json: people
  end

  def show
    
  end

  # GET /people
  def index
    @people = current_user.people.order(created_at: :desc).page params[:page]
  end

  # GET /people/new
  def new
    @person = Person.new
  end

  # GET /people/:id/edit
  def edit
    @person = current_user.people.find(params[:id])
  end

  # PATCH/PUT /people/:id
  def update
    @person = current_user.people.find(params[:id])
    if @person.update(person_params)
      flash[:notice] = "#{@person.name} was saved."
    else
      flash[:alert] = "There was an error saving #{@person.name}."
    end
    redirect_to edit_person_path(@person)
  end

  # POST /people
  def create
    @person = current_user.people.build(person_params)
    if @person.save
      flash[:success] = "#{@person.name} was created."
      redirect_to edit_person_path(@person)
    else
      flash.now[:alert] = "There was an error creating that person."
      render :new
    end
  end


  private

  def search_params
    params.require(:person).permit(
      :name
    )
  end

  def person_params
    params.require(:person).permit(
      :first_name,
      :middle_name,
      :last_name,
      :title,
      :gender
    )
  end

  def set_person
    @person = Person.find(params[:id])
  end
end
