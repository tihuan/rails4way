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

# Action Callback Class
class OutputCompressionActionCallback
  def self.after(controller)
    controller.response.body = compress(controller.response.body)
  end
end

class NewspaperController < ActionController::Base
  after_action OutputCompressionActionCallback
end

# Inline Callback Method
class WeblogController < ActionController::Base
  before_action -> { redirect_to new_user_session_path unless authenticated? }
end

# Stream Content
class StreamingController < ApplicationController
  include ActionController::Live

  # Streams about 180MB of generated data to the browser
  def stream
    10_000_000.times do |i|
      response.stream.write "This is line#{i}\n"
    end
  ensure
    response.stream.close
  end
end
