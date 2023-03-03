class PeopleController < ApplicationController
    before_action :redirect_unauthenticated

    def search
        people = current_user.people.search(search_params).first(10)

        render json: people
    end


    private

    def search_params
        params.require(:person).permit(
            :name
        )
    end
end
