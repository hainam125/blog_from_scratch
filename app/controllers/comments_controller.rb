class CommentsController < ApplicationController
  before_action :find_resource, only: [:edit, :show, :update, :destroy]
  before_action :find_commentable
  
  def new
    @comment = @commentable.comments.build
	@post = Post.find(params[:post_id])
  end
  def create
	@post = Post.find(params[:post_id])
	@comment = @commentable.comments.build(comment_params)
	@comment.user = current_user
	respond_to do |format|
	  if @comment.save
	    format.html { redirect_to @post }
	  else
		flash.now[:warning] = "Something wrong"
	    format.html { render 'posts/show' }
	  end
	end
  end
  def edit
    @comment = current_resource
	@post = Post.find(params[:post_id])
  end
  def update
	@post = Post.find(params[:post_id])
    @comment = Comment.find(params[:id])
	respond_to do |format|
	  if @comment.update_attributes(comment_params)
	    format.html { redirect_to @post }
	  else
		flash.now[:warning] = "Something wrong"
	    format.html { render 'posts/show' }
	  end
	end
  end
  private
    def current_resource
	  @current_resource ||= Comment.find_by(id: params[:id])
	end
	def find_resource
	  redirect_back_or_default(root_path, "Something wrong!") unless @current_resource
	end
	def find_commentable
	  resource, id = request.path.split("/")[1,2]
	  @commentable = resource.singularize.classify.constantize.find(id)
	end
	def comment_params
	  params.require(:comment).permit(:content)
	end
end
