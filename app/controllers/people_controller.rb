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
    respond_to do |format|
      format.html do
        render :index
      end
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(:people, partial: "collection") +
          turbo_stream.replace(:people_page_bar, partial: "page_bar")
      end
    end
  end

  # GET /people/new
  def new
    @person = Person.new
  end

  # PATCH/PUT /people/:id
  def update
    respond_to do |format|
      if @person.update(person_params)
        # format.turbo_stream do
        #   flash.now[:alerts].append Alert::Success.new(model: @person).flash
        #   render turbo_stream: 
        #     turbo_stream.replace(:person_form, partial: 'form') +
        #     turbo_stream.replace(:person_header, partial: 'header_member') +
        #     turbo_stream.append(:alerts, partial: "layouts/alert")
        # end
        format.html do
          alerts.append Alert::Success.new(model: @person).flash
          redirect_to tab_person_path(@person, :info)
        end
      else
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(:person_form, partial: 'form')
        end
        format.html do
          @tab = :info
          render :show
        end
      end
    end
  end

  # POST /people
  def create
    respond_to do |format|
      @person = current_user.people.build(person_params)
      if @person.save
        # format.turbo_stream { 
        #   render turbo_stream: 
        #     turbo_stream.replace(:person_form, partial: 'form') +
        #     turbo_stream.replace(:person_header, partial: 'header_member') +
        #     turbo_stream.replace(:person_body, partial: 'body') +
        #     turbo_stream.append(:alerts, partial: "layouts/alert")
        # }
        format.html do
          alerts.append Alert::Success.new(model: @person).flash
          redirect_to tab_person_path(@person, :info)
        end
      else
        @person.avatar.detach
        format.html do
          alerts_now.append Alert::Error.new(title: "Not saved").flash
          render :new
        end
      end
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
      @note = @person.notes.build
      @notes = @person.notes.order(created_at: :desc).page(page)
      @tab = :notes
    when :mentions
      @entries = @person.entries.page(page)
      @tab = :mentions
    when :biography
      @tab = :biography
    else
      @tab = :info
    end
    respond_to do |format|
      format.html { render :show }
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(:person_body, 'body')
      end
    end
  end

  # GET /people/:id/edit
  def edit
    # This redirect is here so that the edit_person_path method can be used
    # in polymorphic helper methods such as those in dropdown_helper.rb
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
end
