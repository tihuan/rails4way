# error_message_on(object, method, *options)
.form_field
  .field_label
    %span.required *
    %label First Name
  .textual
    = form.text_field :first_name
    = form.error_message_on :first_name

# error_message_for(*params)
# when used with form, use error_messages instead
= form_for @person do |form|
  = form.error_messages
  .text-field
    = form.label :name, "Name"
    = form.text_field :name

# Custom validation error display
# highlighting error with div .field_with_errors accomplished
# via a Proc object in ActionView::Base class:
module ActionView
  class Base
    cattr_accessor :field_error_proc
    @@field_error_proc = Proc.new{ |html_tag, instance|
      "<div class=\"field_with_errors\">#{html_tag}</div>".html_safe
    }
  end
end

# customize validation error display
# inside an initializer file
ActionView::Base.field_error_proc =
  Proc.new do |html_tag, instance|
    %(<div style="color:red>ERR</div>") + html_tag
  end

# Using Assets Host
# config/environments/produciton.rb
config.action_controller.asset_host = "assets.exmaple.com"

# Displaying existing values
# Using gem Decent Exposure
expose(:person) do
  if person_id = (params[:person_id] || params[:id])
    Person.find(person_id)
  else
    # Set default values that you want to appear in the form
    Person.new(first_name: "First", last_name: "Last")
  end
end

# Nested Attributes in a form
# Use accepts_nested_attributes_for
class Person < ActiveRecord::Base
  has_one :address
  accepts_nested_attributes_for :address, allow_destroy: true
end

# Having allow_destroy means we can destroy the associated model
# in form control using _destroy form element
= form_for person do |f|
  = f.fields_for :address do |address_fields|
    Delete this address:
    = address_fields.check_box :_destroy

# One to Many Association
class Person < ActiveRecord::Base
  has_many :projects
  accepts_nested_attributes_for :projects, allow_destroy: true
end

# Form
= form_for person do |form|
  = form.fields_for :projects do |project_fields|
    Delete this project
      = project_fields.check_box :_destroy

# Custom Helper Methods

# page_title helper
# app/helpers/application_helper.rb
def page_title(name)
  content_for(:title) { name }
  content_tag("h1", name)
end

# application.html.haml
%html
  %head
    %title= yield :title

# view template
- page_title("New User")
= form_for(user) do |f|
  ...

# photo_for helper OR use Paperclip / CarrierWave
def photo_for(user, size=:thumb)
  if user.profile_photo
    src = user.profile_photo.public_filename(size)
  else
    src = 'user_placerholder.png'
  end
  link_to(image_tag(src), user_path(user))
end

# Tile Display Partial
%table.cities.tiles
  - cities.in_groups_of(columns) do |row|
    %tr
      - row.each do |city|
        %td[city]
          .left
            = image_tag(city.photo.url(:thumb))
          .right
            .title
              = city.name
            .description
              = city.description
