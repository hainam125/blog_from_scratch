class PostsController < ApplicationController
  before_action :find_resource, only: [:show, :edit, :update, :destroy]
  before_action :store_location, only: :show
  def index
    @posts = Post.order('created_at DESC').paginate(page: params[:page], per_page: 5)
	respond_to do |format|
	  format.html
	  format.js
	end
  end

  def show
	@post = current_resource
	@comment = Comment.new
  end

  def new
	@post = Post.new
  end
  def create
	@post = Post.new(post_params)
	@post.user = current_user
	if @post.save
	  flash[:success] = "Your post have been created!"
	  redirect_to @post
	else
	  render 'new'
	end
  end

  def edit
	@post = current_resource
  end
  def update
	@post = current_resource
	if @post.update_attributes(post_params)
	  flash[:success] = "Your post have been updated!"
	  redirect_to @post
	else
	  render 'edit'
	end
  end
  def destroy
	Post.find(params[:id]).destroy
	redirect_to root_path
  end
  private
	def find_resource
	  redirect_back_or_default(root_path, "Not found!") unless @current_resource
	end
    def current_resource
	  @current_resource ||= Post.find_by(id: params[:id])
	end
	def post_params
	  params.require(:post).permit(:title, :content)
	end
end
