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
