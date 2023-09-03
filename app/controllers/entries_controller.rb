class EntriesController < ApplicationController
  before_action :redirect_unauthenticated
  before_action :set_entry, only: %i[ show edit update destroy ]

  # GET /entries/search
  def search
    @keyword = keyword
    results = Entry.search(keyword, page: params[:page])
    @entries = Kaminari.paginate_array(results, total_count: results.total_count).page(params[:page]).per(Entry.default_per_page)
    respond_to do |format|
      format.html { render :index }
    end
  end

  # GET /entries
  # GET /entries/:status
  def index
    case params[:status]&.to_sym
    when :drafts
      @entries = current_user.entries.not_deleted.drafts.order(created_at: :desc).page params[:page]
      @index_title = "Drafts"
    else
      @entries = current_user.entries.not_deleted.published.order(published_at: :desc).page
      @index_title = "Published"
    end
    render :index
  end

  # GET /entries/:id
  def show
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
    if @entry.update(entry_params)
      respond_to do |format|
        format.turbo_stream do
          @save_bar_message = {
            class: "text-green-400",
            message: @entry.published? ? "Published" : (@entry.status_before_last_save == "published" ? "Unpublished" : "Saved")
          }
          render turbo_stream: turbo_stream.update('entry-save-bar', partial: 'save_bar')
        end
        format.html { redirect_to edit_entry_path(@entry) }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          @save_bar_message = {
            class: "text-red-400",
            message: "Not saved"
          }
          render turbo_stream: turbo_stream.update('entry-save-bar', partial: 'save_bar')
        end
        format.html { render :edit, status: :unprocessable_entity }
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
      :content,
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

  def keyword
    params[:keyword]
  end
end