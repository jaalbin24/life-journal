class MentionsController < ApplicationController
  before_action :redirect_unauthenticated
  before_action :set_mention, only: %i[ destroy ]
  before_action :set_entry, only: %i[ new create ]


  def destroy
    @mentions = @mention.entry.mentions
    if @mention.destroy

    else

    end
    respond_to do |format|
      format.turbo_stream do 
        render turbo_stream: turbo_stream.update('mentions', partial: 'collection')
      end
    end
  end

  # GET /entry/:entry_id/mentions?keyword=XYZ
  def new
    @keyword = params[:keyword]
    results = Person.search(@keyword, type: :autocomplete).first(Person.default_per_page)
    @mentions = results.map do |p|
      @entry.mentions.build(
        person: p,
        entry: @entry
      )
    end
    respond_to do |format|
      format.turbo_stream do 
        render turbo_stream: turbo_stream.update('new-mentions', partial: 'new')
      end
    end
  end

  # POST /entry/:entry_id/mentions?keyword=XYZ
  def create
    if @entry.mentions.create(mention_params)

    else

    end
    @mentions = @entry.mentions
    respond_to do |format|
      format.turbo_stream do 
        render turbo_stream: turbo_stream.update('mentions', partial: 'collection')
      end
    end
  end

  private

  def set_mention
    @mention = current_user.mentions.find(params[:id])
  end

  def set_entry
    @entry ||= current_user.entries.find(params[:entry_id])
  end

  def mention_params
    params.require(:mention).permit(
      :person_id,
      :entry_id
    )
  end
end
