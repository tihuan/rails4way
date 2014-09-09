# error_message_on(object, method, *options)
.form_field
  .field_label
    %span.required *
    %label First Name
  .textual
    = form.text_field :first_name
    = form.error_message_on :first_name
