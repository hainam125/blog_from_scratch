module ApplicationHelper
  def sign_in(user)
	session[:user_id] = user.id
  end
  def user_signed_in?
	!current_user.nil?
  end
  def current_user
	if session[:user_id]
	  @current_user = User.find_by(id: session[:user_id])
	elsif cookies[:user_id]
	  user = User.find_by(id: cookies.signed[:user_id])
	  if user && user.authenticate?(:remember,cookies.signed[:remember_token])
		@current_user = user
	  end
	end
  end
  def current_user?(user)
	current_user == user
  end
  def remember_user(user)
	user.create_remember
	cookies.permanent.signed[:remember_token] = user.remember_token
	cookies.permanent.signed[:user_id] = user.id
  end
  def forget
	current_user.forget
    cookies.delete(:remember_token)
	cookies.delete(:user_id)
  end
  def sign_out
    forget #nam trc
	session.delete(:user_id)
	@current_user = nil
  end

  def store_location
	session[:return_to] = request.original_url
  end
  def redirect_back_or_default(default, msg=nil)
	flash[:warning] = msg if msg
	redirect_to(session[:return_to]||default)
	session.delete(:return_to)
  end

  def vote_button_for_resource(resource)
	user = current_user
	if user
	  voted = user.vote_this?(resource)
	  vote = resource.votes.where(user_id: user.id).first if voted
	end
	directions = %w[down up]
	[1,2].each do |n|
	  if voted && vote.value == n #destroy
	    method = "delete"
		css_class = "btn btn-info"
		#path = vote_path(vote, post_id: @post.id)
		path = polymorphic_path([resource, vote], this_post_id: @post.id)
	  elsif voted #edit
	    method = "patch"
		css_class = "btn btn"
		#path = vote_path(vote, value: n, post_id: @post.id)
		path = polymorphic_path([resource, vote], value: n, this_post_id: @post.id)
	  else #create
	    method = "post"
		css_class = "btn btn-default"
		path = polymorphic_path([resource, :votes], value: n, this_post_id: @post.id)
	  end
	  yield(method, css_class, path, directions[n-1], resource.vote_count(n))
	end
  end
end
