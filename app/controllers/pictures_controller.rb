class PicturesController < ApplicationController
    before_action :redirect_unauthenticated

    # GET entries/:entry_id/pictures/new
    def new
        @entry = current_user.entries.find(params[:entry_id])
        @picture = @entry.pictures.build
    end

    # POST entries/:entry_id/pictures
    def create
        @entry = current_user.entries.find(params[:entry_id])
        @picture = @entry.pictures.build(picture_params)
        if @picture.save
            render json: @picture
        else
            head 400
        end
    end

    # GET /pictures/:id
    def show
        picture = Picture.find(params[:id])
        render json: picture
    end

    # DELETE entries/:entry_id/pictures/:picture_id
    def delete
        @entry = current_user.entries.find(params[:entry_id])
        @picture = @entry.pictures.find(params[:picture_id])
    end

    # PATCH/PUT pictures/:id
    def update
        picture = Picture.find(params[:id])
        if picture.update(picture_params)
            render json: picture
        else
            head 400
        end
    end

    # GET entries/:entry_id/pictures
    def index
        entry = current_user.entries.find(params[:entry_id])
        @pictures = entry.pictures.find(params[:id])
    end

    private

    def picture_params
        params.require(:picture).permit(
            :description,
            :title,
            :file
        )
    end
end
