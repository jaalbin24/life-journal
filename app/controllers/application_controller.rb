class ApplicationController < ActionController::Base
    include Authentication

    before_action :configure_continue_path

    def configure_continue_path
        @continue_path ||= params[:continue_path]
    end

    def continue_path(args={fallback_location: fbl_path})
        @continue_path ? @continue_path : fbl_path
    end
end
