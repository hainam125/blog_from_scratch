class VotesController < ApplicationController
  before_action :find_vote, only: [:update, :destroy]
  before_action :find_votable
  def create
	user = current_user
	@post = Post.find(params[:this_post_id])
	vote = @votable.votes.build(value: params[:value])
	vote.voting_user = current_user
	respond_to do |format|
	  format.html { redirect_to @post}
	  if vote.save
		format.js { render 'voting.js.erb'}
	  else
	    flash[:warning] = "Opp! Something wrong!"
	  end
	end
  end
  
  def update
	@post = Post.find(params[:this_post_id])
	respond_to do |format|
	  if @vote.update_attributes(value: params[:value])
		format.js { render 'voting.js.erb'}
	  else
	    flash[:warning] = "Opp! Something wrong!"
	  end
	  format.html { redirect_to @post}
	end
  end
  
  def destroy
	@post = Post.find(params[:this_post_id])
	@vote.destroy
	respond_to do |format|
	  format.html { redirect_to @post}
	  format.js { render 'voting.js.erb'}
	end
  end
  private
    def find_vote
	  @vote = Vote.find_by(id: params[:id])
	  redirect_back_or_default(root_path, "Something wrong!") unless @vote
	end
	def find_votable
	  resource, id = request.path.split("/")[1,2]
	  @votable = resource.singularize.classify.constantize.find(id)
	end
end
