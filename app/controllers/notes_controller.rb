class NotesController < ApplicationController
    before_action :set_notable
    # POST /[notable]/:notable_id/notes
    def create
        redirect_to notable_path
    end

    private

    def set_notable
        @notable = Person.find(params[:person_id]) if params[:person_id]
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
