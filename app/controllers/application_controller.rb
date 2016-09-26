class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include ApplicationHelper
  delegate :allow_action?, to: :current_permission
  helper_method :allow_action?
  before_action :authorize
  
  private
	def current_resource
	  nil
	end
	def current_permission
	  @current_permission = Permission.new(current_user)
	end
	def authorize
	  if !current_permission.allow_action?(params[:controller], params[:action], current_resource)
	    current_permission.redirect_to_path(params[:controller]) do |msg|
		  redirect_back_or_default(root_path, msg) 
		end
	  end
	end
end
