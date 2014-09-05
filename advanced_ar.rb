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

# Cross-model scope
# Retrieve users with late submissions
class User < AcitveRecord::Base
  scope :tardy, -> {
    joins(:timesheets).
    where("timesheets.submitted_at <= ?", 7.days.ago).
    group("users.id")
  }
end

# Use to_sql to debug scope definitions and usage
User.tardy.to_sql
# => "SELECT "users".* FROM "users"
      # INNER JOIN "timesheets" ON "timesheets"."user_id" = "users"."id"
      # WHERE (timesheets.submitted_at <= '2014-04-13 18:16:15.203293')
      # GROUP BY users.id"
