class NotesController < ApplicationController
    before_action :set_notable
    # POST /[notable]/:notable_id/notes
    def create
        note = @notable.notes.build notable_params
        note.user = current_user
        if note.save
            flash[:success] = "Your note was created: \"#{note.content}\""
        else
            flash[:alert] = "There was an error creating this note."
        end
        redirect_to notable_path
    end

    # DELETE notes/:id
    def destroy
        note = current_user.notes.find(params[:id])
        if note.destroy
            flash[:notice] = "Your note was deleted: \"#{note.content}\""
        else
            flash[:alert] = "There was an error deleting this note."
        end
        redirect_to notable_path
    end

    private

    def set_notable
        @notable = current_user.people.find(params[:person_id]) if params[:person_id]
        @notable = current_user.notes.find(params[:id]).notable if params[:id]

    end

    def notable_params
        params.require(:note).permit(
            :content
        )
    end

    def notable_path
        case @notable.class.to_s.downcase.to_sym
        when :person
            edit_person_path(@notable)
        else
            raise StandardError.new "Unhandled notable type: #{@notable.class.to_s.downcase.to_sym}"
        end
    end
end
