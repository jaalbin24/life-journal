class ApplicationController < ActionController::Base
    include Authentication

    before_action :configure_continue_path

    def configure_continue_path
        @continue_path ||= params[:continue_path]
    end
end
