class NotesController < ApplicationController
  before_action :set_person,  only: %i[ create ]
  before_action :set_note,    only: %i[ destroy ]
  before_action :set_notes,   only: %i[ create ]
  # POST /person/:person_id/notes
  def create
    respond_to do |format|
      @note = @person.notes.build note_params
      @note.user = current_user
      if @note.save
        @note = Note.new
        format.turbo_stream do
          render turbo_stream: 
            turbo_stream.replace(:notes_collection, partial: 'collection') +
            turbo_stream.replace(:notes_form, partial: 'form')
        end
      else
        format.turbo_stream do
          render turbo_stream: 
            turbo_stream.replace(:notes_collection, partial: 'collection') +
            turbo_stream.replace(:notes_form, partial: 'form')
        end
      end
    end
  end

  # DELETE notes/:id
  def destroy
    respond_to do |format|
      if @note.destroy
        format.html { redirect_to tab_person_path(@person, :notes) }
      else
        format.html { redirect_to tab_person_path(@person, :notes) }
      end
    end
  end

  private

  def set_person
    @person = current_user.people.find(params[:person_id])
  end
  def set_note
    @note = current_user.notes.find(params[:id])
  end
  def set_notes
    @notes = @person.notes.order(created_at: :desc).page(page)
  end

  def note_params
    params.require(:note).permit(
      :content
    )
  end
end
