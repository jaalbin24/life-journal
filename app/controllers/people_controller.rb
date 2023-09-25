class PeopleController < ApplicationController
  before_action :redirect_unauthenticated
  before_action :set_person, only: %i[ show update destroy ]

  def search
    @keyword = keyword
    results = Person.search(keyword, page: page, type: params[:type])
    @people = Kaminari.paginate_array(results, total_count: results.total_count).page(page).per(Person.default_per_page)
    respond_to do |format|
      format.html { render :index }
      format.turbo_stream do 
        render turbo_stream: turbo_stream.update('search-results', partial: 'search_results')
      end
    end
  end

  # GET /people
  def index
    case tab
    when :trash
      @tab = :trash
      @people = current_user.people.deleted.order(deleted_at: :desc).page page
    else
      @tab = :all
      @people = current_user.people.not_deleted.order(updated_at: :desc).page page
    end
  end

  # GET /people/new
  def new
    @person = Person.new
  end

  # PATCH/PUT /people/:id
  def update
    if @person.update(person_params)
      redirect_to tab_person_path(@person, :info)
    else
      @tab = :info
      respond_to do |format|
        format.html { render :show }
      end
    end
  end

  # POST /people
  def create
    @person = current_user.people.build(person_params)
    if @person.save
      redirect_to tab_person_path(@person, :info)
    else
      @person.avatar.detach
      render :new
    end
  end

  # DELETE /people/:id
  def destroy
    if @person.destroy
      redirect_to people_path
    else
      redirect_to @person, alert: "There was an error deleting #{@person.name}."
    end
  end

  # GET /people/:id/:tab/page/:page
  def show
    case tab
    when :notes
      @notes = @person.notes.page(page)
      @tab = :notes
    when :mentions
      @entries = @person.entries.page(page)
      @tab = :mentions
    when :biography
      @tab = :biography
    else
      @tab = :info
    end
  end

  # GET /people/:id/edit
  def edit
    redirect_to tab_person_path(tab: :info)
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
      :avatar,
      :deleted
    )
  end

  def set_person
    @person = current_user.people.find(params[:id])
  end

  def keyword
    params[:keyword]
  end

  def tab
    params[:tab]&.to_sym
  end

  def page
    params[:page] || 1
  end
end
