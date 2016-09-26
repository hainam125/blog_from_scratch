class UsersController < ApplicationController
  before_action :find_user, only: [:show, :edit, :update, :destroy]
  before_action :store_location, only: [:show, :followers, :following, :index] #after redirect
  def index
    @users = User.all
  end

  def show
	@user_posts = @user.authoring_posts.order("created_at DESC").paginate(page: params[:page], per_page: 5 )
	respond_to do |format|
	  format.html
	  format.js
	end
  end

  def new
	@user = User.new
  end
  def create
	@user = User.new(user_params)
	if @user.save
	  flash[:success] = "Thank you for sign up!"
	  sign_in(@user)
	  redirect_to @user
	else
	  render 'new'
	end
  end

  def edit
  end
  def update
	if @user.update_attributes(user_params)
	  flash[:success] = "Your account have been updated!"
	  redirect_to @user
	else
	  render 'edit'
	end
  end
  def destroy
	@user.destroy
	redirect_to users_path
  end
  def following
	@user = User.find(params[:user_id])
	@users = @user.following
	@id = "following"
	render "follow_list"
  end
  def followers
	@user = User.find(params[:user_id])
	@users = @user.followers
	@id = "followers"
	render "follow_list"
  end
  
  private
	def find_user
	  @user = User.find_by(id: params[:id])
	  redirect_back_or_default(root_path, "Not found") unless @user
	end
	def user_params
	  params.require(:user).permit(:username, :email, :password,)
	end
end
