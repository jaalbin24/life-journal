class PicturesController < ApplicationController
    before_action :redirect_unauthenticated

    # GET entries/:entry_id/pictures/new
    def new
        @entry = Entry.find(params[:entry_id])
        @picture = @entry.pictures.build
    end

    # POST entries/:entry_id/pictures
    def create
        @entry = Entry.find(params[:entry_id])
        @picture = @entry.pictures.build(picture_params)
        if @picture.save

        else
            
        end
    end

    # DELETE entries/:entry_id/pictures/:picture_id
    def delete
        @entry = Entry.find(params[:entry_id])
        @picture = @entry.pictures.find(params[:picture_id])
    end

    # PATCH/PUT entries/:entry_id/pictures/:picture_id
    def update

    end

    private

    def picture_params
        params.require(:picture).allow(
            :description,
            :file
        )
    end
end
