class EntriesController < ApplicationController
  before_action :redirect_unauthenticated
  before_action :set_entry, only: %i[ show edit update destroy ]

  # GET /entries
  def index
    @entries = current_user.entries.not_deleted.published.order(published_at: :desc).page params[:page]
  end

  # GET /entries/drafts
  def drafts
    @entries = current_user.entries.not_deleted.drafts.not_empty.order(created_at: :desc).page params[:page]
    render :drafts
  end

  # GET /entries/:id
  def show
  end

  # GET /entries/new
  def new
    empty_draft = current_user.entries.drafts.empty.first
    if empty_draft
      @entry = empty_draft
      @entry.touch
    else
      @entry = current_user.entries.create(
        status: "draft",
      )
    end
  end

  # GET /entries/:id/edit
  def edit
  end

  # POST /entries
  def create
    @entry = current_user.entries.build(entry_params)
    if @entry.save!
      flash[:success] = "Entry was successfully created#{": #{@entry.title}"}."
      redirect_to @entry
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /entries/:id
  def update
    if @entry.update(entry_params)
      flash[:notice] = "Your entry was #{@entry.published? ? 'published' : 'saved'}."
      redirect_to edit_entry_path(@entry)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /entries/:id
  def destroy
    if @entry.mark_as_deleted
      redirect_to entries_url, notice: "Your entry was deleted."
    else
      redirect_to @continue_path, alert: "Your entry could not be deleted."
    end
  end

  private
  
  # Use callbacks to share common setup or constraints between actions.
  def set_entry
    @entry = current_user.entries.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def entry_params
    params.require(:entry).permit(
      :text_content,
      :title,
      :status,
      mentions_attributes: [
        :id,
        :person_id,
        :_destroy
      ],
      pictures_attributes: [
        :file,
        :id,
        :_destroy
      ]
    )
  end
end