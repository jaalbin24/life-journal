class EntriesController < ApplicationController
  before_action :redirect_unauthenticated
  before_action :set_entry, only: %i[ show edit update destroy ]

  # GET /entries
  def index
    @entries = current_user.entries.published.order(published_at: :desc).page params[:page]
  end

  # GET /entries/drafts
  def drafts
    @entries = current_user.entries.drafts.order(created_at: :desc).page params[:page]
    render :drafts
  end

  # GET /entries/1
  def show
  end

  # GET /entries/new
  def new
    @entry = current_user.entries.build(
      status: "draft"
    )
  end

  # GET /entries/1/edit
  def edit
  end

  # POST /entries
  def create
    @entry = current_user.entries.build(entry_params)

    if @entry.save!
      redirect_to @entry, notice: "Entry was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /entries/1
  def update
    if @entry.update(entry_params.reject {|e| e['picture_of_the_day']})
      if entry_params[:picture_of_the_day].present?
        @entry.picture_of_the_day.purge if @entry.picture_of_the_day.attached?
        @entry.picture_of_the_day.attach(entry_params[:picture_of_the_day])
      end
      redirect_to @entry, notice: "Entry was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /entries/1
  def destroy
    @entry.mark_as_deleted
    if @entry.save
      redirect_to entries_url, notice: "Entry was deleted."
    else
      redirect_to @continue_path, notice: "Entry could not be destroyed."
    end
  end

  private
  
  # Use callbacks to share common setup or constraints between actions.
  def set_entry
    @entry = Entry.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def entry_params
    params.require(:entry).permit(
      :text_content,
      :title,
      :published,
      mentions_attributes: [
        :id,
        :person_id,
        :_destroy
      ]
    )
  end
end