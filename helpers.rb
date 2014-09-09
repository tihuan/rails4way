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


