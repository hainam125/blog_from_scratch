class Permission
  def initialize(user)
	allow_action :sessions, [:new, :create, :destroy]
	allow_action :users, [:new, :create, :show, :followers, :following]
	allow_action :posts, [:index,:show]
	if user
	  allow_action :users, [:edit, :update]
	  allow_action :votes, [:create, :update, :destroy]
	  allow_action :relationships, [:create, :destroy]
	  allow_action [:posts, :comments], [:new, :create]
	  allow_action [:posts,:comments], [:edit, :update] do |resource|
		resource.user_id == user.id
	  end
	  
	  allow_all if user.admin? 
	end
  end
  
  def allow_all
	@allow_all ||= true
  end
  def allow_action(controllers, actions, &block)
	@allowed_action ||= {}
	Array(controllers).each do |controller|
	  Array(actions).each do |action|
		@allowed_action[[controller.to_s, action.to_s]] = block || true
	  end
	end
  end
  def allow_action?(controller, action, resource=nil)
	allowed = @allow_all || @allowed_action[[controller.to_s, action.to_s]]
	allowed && (allowed == true || resource && allowed.call(resource))
  end
  def redirect_path(controller)
	@path = [:root, "Not authorized!"]
	@path = [:log, "Please sign in"] if controller.to_s == "votes"
	@path
  end
  def redirect_to_path(controller)
	msg = "Not authorized!"
	msg = "Please sign in!" if controller.to_s == "votes"
	yield(msg)
  end
end