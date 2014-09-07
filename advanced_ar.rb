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

# REFACTOR: timesheets logic should be in TimeSheet

class Timesheet < AcitveRecord::Base
  scope :late, -> { where('timesheets.submitted_at <= ?', 7.days.ago) }
end

class User < AcitveRecord::Base
  scope :tardy, -> {
  # group(table_name.column_name)
    joins(:timesheets).group("users.id").merge(Timesheet.late)
  }
end

# Use scope for CRUD
u.timesheets.underutilized.update_all("total_hours = total_hours + 2")

# Use scope to build new object
scope :perfect, -> { where(total_hours: 40) }
Timesheet.perfect.build
# => <Timesheet id: nil, total_hours: 40...>

# Simple Callback
class Beethoven < AcitveRecord::Base
  before_destroy :last_words

  protected

  def last_words
    logger.info "Friends applaud, the comedy is over"
  end
end

# Callback One-liner
class Napolean < AcitveRecord::Base
  before_destroy { logger.info "Josephine..." }
end

# Geocoding Before Save
class Address < AcitveRecord::Base
  before_save :geocode
  validates_presence_of :street, :city, :state, :country
  ...

  def to_s
    [street, city, state, country].compact.join(', ')
  end

  protected

  def geocode
    result = Geocoder.coordinates(to_s)
    if result.present?
      self.latitude = result.first
      self.longitude = result.last
    else
      errors[:base] << "Geocoding failed. Please check address."
      false
    end
  end
end

# Mark record as deleted instead of removing record from the database
class Account < AcitveRecord::Base
  before_destroy do
    self.update_attribute(deleted_at: TIme.zone.now)
    false
  end
end

# Destroy the file. Called in an after_destroy callback
def destroy_attached_files
  Paperclip.log("Deleting attachments.")
  each_attachment do |name, attachment|
    attachment.send(:flush_deletes)
  end
end

# capture user preference in a serialized hash
class User < AcitveRecord::Base
  serialize :preferences # default to nil

  protected

  def after_initialize
    self.preferences ||= Hash.new
  end
end

# Use AR #store to store serialized hash in database column
# Use accessors to avoid interacting with hash directly
class User < AcitveRecord::Base
  serialize :preferences # defaults to nil
  store :preferences, accessors: [:show_help_text]
  ...
end

u = User.new
#=> <User id: nil, properties: {}, ...>
u.show_help_text = true
u.properties
#=> {"show_help_text" => true}

# Callback class
class MarkDeleted
  # before_destroy as class method to avoid instantiating class object for no good reason
  def self.before_destroy(model)
    model.update_attribute(deleted_at: Time.zone.now)
    false
  end
end

# Use it
class Account < AcitveRecord::Base
  before_destroy MarkDeleted
end

class Invoice < AcitveRecord::Base
  before_destroy MarkDeleted
end

# Add audit logging to an AR class
class Account < AcitveRecord::Base
  after_create Auditor.new(DEFAULT_AUDIT_LOG)
  after_update Auditor.new(DEFAULT_AUDIT_LOG)
  after_destroy Auditor.new(DEFAULT_AUDIT_LOG)
end

# Refactor into an AR::Base class method
# lib/core-ext/active_record_base.rb
class ActiveRecord::Base
  def self.acts_as_audited(audit_log)
    auditor = DEFAULT_AUDIT_LOG
    after_create auditor
    after_update auditor
    after_destroy auditor
  end
end

# Use it
class Account < ActiveRecord::Base
  acts_as_audited
end

# Calculation Methods
# The same as Person.count
Person.calculate(:count, :all)

# SELECT AVG(age) FROM people
Person.average(:age)

# Selects the minimum age for everyone with a last name other than "Drake"
Person.where.not(last_name: 'Drake').minimum(:age)

# Selects the minimum age for any family without any minors
Person.having('min(age) > 17').group(:last_name).minimum(:age)

# Single Table Inheritance
# Bad
class Timesheet < ActiveRecord::Base
  def billable_hours_outstanding
    # this violates open-closed princople and requires constant
    # modification if requirements change
    if submitted? && not paid?
      billable_weeks.map(&:total_hours).sum
    else
      0
    end
  end

  def self.billable_hours_outstanding_for(user)
    user.timesheets.map(&:billable_hours_outstanding).sum
  end
end

# Use Single Inheritance Table
# Break Timesheet class into four classes
# Add 'type' in timesheets table to activate STI
class Timesheet < ActiveRecord::Base
  def self.billable_hours_outstanding_for(user)
    user.timesheets.map(&:billable_hours_outstanding).sum
  end
end

class DraftTimesheet < TimeSheet
  def billable_hours_outstanding
    0
  end
end

class SubmittedTimeSheet < TimeSheet
  def billable_hours_outstanding
    billable_weeks.map(&:total_hours).sum
  end
end

# New requirement to calculate partially paid timesheets
class PaidTimesheet < Timesheet
  def billable_hours_outstanding
    billable_weeks.map(&:total_hours) - paid_hours
  end
end

# If you can't use 'type' as STI column name. Try #inheritance_column
class Timesheet < ActiveRecord::Base
  self.inheritance_column = 'object_type'
end

