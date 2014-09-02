# Use logger.warn to warn the team a potential malicious behavior of users

def create
  begin
    group.add_member(current_user)
    flash[:notice] = "Successfully joined #{scene.display_name}"
  rescue ActiveRecord::RecordInvalid
    flash[:error] = "You are already a member of #{group.name}"
    logger.warn "A user tried to join a gropu twice. UI should not have allowed it."
  end

  redirect_to :back
end

# Routing
# Ability to dispatch to a Rack-based application

class HelloApp < Sinatra::Base
  get "/" do
    "Hello World!"
  end
end

Example::Application.routes.draw do
  mount HelloApp, at: '/hello'
end

# or, simply:
mount "HelloApp" => '/hello'

# Segment Key Constraint
# First route only accepts numerical parameter as :id
# If :id is not numerical, it will fall through to the second route and show error
get ':controller/show/:id' => :show, constraints: {:id => /\d+/}
get ':controller/show/:id' => :show_error

# shorthand

get ':controller/show/:id' => :show, id: /\d+/
get ':controller/show/:id' => :show_error

# restrict subdomain
get ':controller/show/:id' => :show, constraints: {subdomain: 'admin'}

# protect records with id under 100
get 'records/:id' => "records#protected",
  constraints: -> { |req| req.params[:id].to_i < 100 }

# root route
root :to => "welcome#index"
root :to => "pages#home"
root "user_sessions#new"
