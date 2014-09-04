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

# route globbing
/items/list/base/fiction/dickens

/items/list/base/books/fiction

/items/list/base/books/fiction/dickens/little_dorrit

# Try globbing
get '/items/list/*specs' => "items#list"

# Globbing in action
get 'items/q/*specs', controller: "items", action: "query"

# ItemsController << ApplicationController
def query
  @items = Item.where(Hash[*params[:specs].split("/")])
  if @items.empty?
    flash[:error] = "Can't find items with those properties"
  else
    render :index
  end
end

# named route: route.rb
get 'help' => 'help#index', as: 'help'
# Rails way prefer name_path over name_url
link_to "Help", help_path

# Test name_pth in rails c
app.help_path #=> "/help"
app.help_url #=> "http://www.exmaple.com/help"

# name_path in action
link_to "Auction of #{item.name}", item_path(item)
# /auction/5/item/1
link_to "Auction of #{item.name}", item_path(auction, item)

# Modify url string by overriding to_params in the model.rb
# item.rb
def to_param
  description.parameterize
end

# call item_path(auction, item) produces the following:
'/auction/5/item/cello-bow'

# CAUTION: Since we now have 'cello-bow' in our :id field. We need
# a separate database column to store the munged version of the title
# to serve as part of the path. So we can do something like,
# REMEMBER: words in URLs just look better!!
Item.find(munged_description: params[:id])

# Scoping routing rules
# Before
get 'auctions/new' => 'auctions#new'
get 'auctions/edit/:id' => 'auctions#edit'
get 'auctions/pause/:id' => 'auctions#pause'
# After
scope path: '/auctions', controller: :auctions do
  get 'new' => :new
  get 'edit/:id' => :edit
  get 'pause/:id' => :pause
end
