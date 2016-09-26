class SessionsController < ApplicationController
  def new
	@user = User.new
  end
  def create
	@user = User.find_by(username: params[:session][:username])
	if @user && @user.authenticate(params[:session][:password])
	  flash[:success] = "Welcome!"
	  sign_in(@user)
	  remember_user(@user) if params[:session][:remember_me] == "1"
	  redirect_to @user
	else
	  flash.now[:danger] = "Invalid username or password!"
	  render 'new'
	end
  end
  def destroy
	sign_out if user_signed_in?
	redirect_to root_path
  end
end