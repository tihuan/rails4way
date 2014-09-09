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
