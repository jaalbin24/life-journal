class EntriesController < ApplicationController
  before_action :redirect_unauthenticated
  before_action :set_entry, only: %i[ show edit update destroy ]

  # GET /entries/search
  def search
    @keyword = keyword
    results = Entry.search(keyword, page: page)
    @entries = Kaminari.paginate_array(results, total_count: results.total_count).page(page).per(Entry.default_per_page)
    respond_to do |format|
      format.html { render :index }
    end
  end

  # GET /entries
  # GET /entries/:status
  def index
    case tab
    when :published
      @tab = :published
      @entries = current_user.entries.not_deleted.published.order(published_at: :desc).page page
    when :drafts
      @tab = :drafts
      @entries = current_user.entries.not_deleted.drafts.order(created_at: :desc).page page
    when :trash
      @tab = :trash
      @entries = current_user.entries.deleted.order(deleted_at: :desc).page page
    else
      @tab = :all
      @entries = current_user.entries.order(updated_at: :desc).page page
    end
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(:entries, partial: "collection") +
          turbo_stream.replace(:entries_page_bar, partial: "page_bar")
      end
      format.html do
        render :index
      end
    end
  end

  # GET /entries/:id
  def show
    respond_to do |format|
      format.html do
        render :show
      end
    end
  end

  # GET /entries/new
  def new
    @entry = Entry.new
  end

  # GET /entries/:id/edit
  def edit
    @mentions = @entry.mentions
  end

  # PATCH/PUT /entries/:id
  def update
    respond_to do |format|
      if @entry.update(entry_params)
        format.turbo_stream do
          @save_bar_message = {
            class: "",
            message: @entry.published? ? "Published" : (@entry.status_before_last_save == "published" ? "Unpublished" : "Saved")
          }
          render turbo_stream: turbo_stream.update('entry-save-bar', partial: 'save_bar')
        end
        format.html do
          alerts.append Alert::Warning.new(title: "This entry was moved to the trash.").flash if @entry.deleted? && !@entry.was_deleted?
          alerts.append Alert::Success.new(title: "This entry was recovered.").flash if !@entry.deleted? && @entry.was_deleted?
          redirect_to @entry, status: :see_other
        end
      else
        format.turbo_stream do
          @save_bar_message = {
            class: "error-message",
            message: "Not saved"
          }
          render turbo_stream: turbo_stream.update('entry-save-bar', partial: 'save_bar')
        end
        format.html { redirect_to @entry, status: :unprocessable_entity }
      end
    end
  end

  # POST /entries
  def create
    @entry = current_user.entries.build(entry_params)
    if @entry.save!
      redirect_to edit_entry_path(@entry)
    else
      render :new, status: :unprocessable_entity
    end
  end

  # DELETE /entries/:id
  def destroy
    if @entry.destroy
      respond_to do |format|
        format.html { redirect_to entries_path }
      end
    else
      respond_to do |format|
        format.html { redirect_to @entry }
      end
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
      :content,
      :title,
      :status,
      :deleted
    )
  end

  def keyword
    params[:keyword]
  end

  def tab
    params[:tab]&.to_sym || :all
  end
end