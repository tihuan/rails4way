# Scope
# define and chain query criteria
class Timesheet < AcitveRecord::Base
  scope :submitted, -> { where(submitted: true) }
  scope :underutilized, ->{ where('total_hours < 40') }
end

class User < AcitveRecord::Base
  scope :deliquent, -> { where('timesheets_updated_at < ?', 1.week.ago) }
end

# Invoke scopes as class methods
User.deliquent

# Scope Parameters
class BillableWeek < AcitveRecord::Base
  scope :newer_than, ->(date) { where('start_date > ?', date) }
end

# Pass in argument
BillableWeek.newer_than(Date.today)
