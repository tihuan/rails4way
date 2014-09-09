# Use Decent Exposure gem
# This example shows how expose declarations can depend on each other
expose(:client)
expose(:timesheet) { client.timesheets.find(params[:id]) }
expose(:timesheet_approval_presenter) do
  TimesheetApprovalPresenter.new(timesheet, current_user)
end

# Use controller.controller_name and controller.action_name to construct css
%body{ class: "#{controller.controller_name} #{controller.action_name}" }
#=> <body class="timesheets index">

# OR, in HAML, use page_class, like so:
%body{ class: page_class }

# Use flash[:notice] and flash[:alert]
def create
  if user.try(:authorize, params[:user][:password])
    redirect_to home_url, notice: "Welcome, #{user.first_name}"
  else
    redirect_to home_url, alert: "Bad login :("
  end
end

# You also have helper method for notice and alert on flash
flash.notice = "Welcome!"
flash.alert = "Uh oh.."

# Displaying flash messages
# Note that .notice.alert means alert uses most of notice's CSS and only does minor modification to accommodate alert style.
# To show flash messages for render template, use flash.now.notice && flash.now.alert
%html
  %body
    -if flash.notice
      .notice= flash.notice
    -if flash.alert
      .notice.alert= flash.alert

      = yield

# Use Partial
# app/views/users/_opt_in.html.haml
%fieldset#opt_in
  %legend Spam Opt In
  %p
    = check_box :user, :send_event_updates
    Send me updates about events!
    %br
    = check_box :user, :send_site_updates
    Notify me about new services

# app/views/users/registration.html.haml
# Note: render can take both symbol and string
%h1 User Registration
= error_emessages_for :user
= form_for :user, url: users_path do
  .registration
    .details.demographics
      = render 'details'
      = render 'demographics'
    .location
      = render 'location'
    .opt_in
      = render :opt_in
    .terms
      = render :terms
  %p= submit_tag 'Register'

# Edit Form
%h1 Edit User
  = form_for :user, url: user_path(@user), method: :put do
    .settings
      .details
        = render 'details'
      .demographics
        = render 'demographics'
    .opt_in
      = render 'opt_in'
 %p= submit_tag 'Save Settings'
