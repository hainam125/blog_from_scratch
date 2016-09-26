class RelationshipsController < ApplicationController
  before_action :find_relationship, only: :destroy
  def create
	@user = User.find(params[:followed_id])
	current_user.follow_this(@user)
	respond_to do |format|
	  format.html {redirect_to :back}
	  format.js
	end
  end
  
  def destroy
	@user = User.find(params[:user_id])
	@relationship.destroy
	respond_to do |format|
	  format.html {redirect_to :back}
	  format.js
	end
  end
  private
	def find_relationship
	  @relationship = Relationship.find_by(id: params[:id])
	  redirect_back_or_default(root_path, "Ops! Something wrong!") unless @relationship
	end
end
