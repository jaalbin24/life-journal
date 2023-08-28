class PeopleController < ApplicationController
  before_action :redirect_unauthenticated
  before_action :set_person, only: %i[ show update destroy ]

  def search
    (redirect_to people_path; return) if query.blank?
    @query = query
    @people = Person.search(query).not_deleted.where(user: current_user).page(params[:page]).per(Person.default_per_page)
    respond_to do |format|
      format.html { render :index }
      format.json { render json: @people }
    end
  end

  # GET /people
  def index
    @people = current_user.people.order(updated_at: :desc).page params[:page]
  end

  # GET /people/new
  def new
    @person = Person.new
  end

  # PATCH/PUT /people/:id
  def update
    if @person.update(person_params)
      redirect_to
    else
      @person.reload
      @tab = :edit
      render :show
    end
  end

  # POST /people
  def create
    @person = current_user.people.build(person_params)
    if @person.save
      flash[:success] = "#{@person.name} was created."
      redirect_to edit_person_path(@person)
    else
      flash.now[:alert] = "There was an error creating that person."
      @person.avatar.detach
      render :new
    end
  end

  # DELETE /people/:id
  def destroy
    if @person.mark_as_deleted
      redirect_to people_path, notice: "#{@person.name} was marked for deletion and will be deleted after 30 days."
    else
      redirect_to @continue_path, alert: "There was an error deleting #{@person.name}."
    end
  end

  # GET /people/:id/:tab/page/:page
  def show
    case params[:tab]&.to_sym
    when :notes
      @notes = @person.notes.page(params[:page])
      @tab = :notes
    when :mentions
      @entries = @person.entries.page(params[:page])
      @tab = :mentions
    when :edit
      @tab = :edit
    else
      @tab = :biography
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
      :gender,
      :nickname,
      :avatar
    )
  end

  def set_person
    @person = current_user.people.find(params[:id])
  end

  def query
    params[:query]
  end
end
