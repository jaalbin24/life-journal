class ApplicationController < ActionController::Base
  include Authentication

  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  before_action { alerts_now.append Alert::Info.new(title: params[:alert]).flash if params[:alert] }
  before_action :init_modal

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

  def init_modal
    @modal = params[:modal] if params[:modal]
  end
end
