# Redirect and Render don't magically halt execution of your controller
# action method. To prevent DoubleRenderError, try this:
def show
  @user = User.find(params[:id])
  if @user.activated?
    # explicitly calling return after redirect_to or render
    render :activated and return
  end
  ...
end

# Recognize that instance variablesin the context
# of controller object is COPIED to view object.
# We can use Decent Exposure to avoid this ugly fact!
