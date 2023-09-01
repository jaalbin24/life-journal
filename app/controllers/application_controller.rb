class ApplicationController < ActionController::Base
  include Authentication

  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  before_action :configure_continue_path

  def configure_continue_path
    @continue_path ||= params[:continue_path]
  end

  def continue_path(args={fallback_location: fbl_path})
    @continue_path ? @continue_path : fbl_path
  end

  def not_found
    render file: "#{Rails.root}/public/404.html", layout: false, status: :not_found
  end
end
