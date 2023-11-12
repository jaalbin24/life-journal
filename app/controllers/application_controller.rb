class ApplicationController < ActionController::Base
  include Authentication

  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  before_action { alerts_now.append Alert::Info.new(title: params[:alert]).flash if params[:alert] }

  def not_found
    render file: "#{Rails.root}/public/404.html", layout: false, status: :not_found
  end

  def page
    params[:page] || 1
  end

  def alerts
    flash[:alerts] ||= []
  end

  def alerts_now
    flash.now[:alerts] ||= []
  end
end
