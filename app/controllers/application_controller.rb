class ApplicationController < ActionController::Base
  include Authentication

  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  before_action :init_alerts

  def init_alerts
    flash[:alerts] ||= []
    flash[:alerts].append Alert::Info.new(title: params[:alert]).flash if params[:alert]
  end

  def not_found
    render file: "#{Rails.root}/public/404.html", layout: false, status: :not_found
  end

  def page
    params[:page] || 1
  end
end
