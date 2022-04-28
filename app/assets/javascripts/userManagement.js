function populateModifyModal() {
  $('#modifyModal').on('show.bs.modal', function(e) {
    var username = e.relatedTarget.dataset.username;

    $(e.currentTarget).find('input[name="user_modify[username]"]').val(username)

    document.addEventListener('input', checkPasswordInputs);
  });
}

document.addEventListener('turbolinks:load', populateModifyModal);

function checkPasswordInputs() {
  var password_field = document.getElementById('user_modify_password');
  var confirmation_field = document.getElementById('user_modify_password_confirmation');
  var update_button = document.getElementById('user_modify_update');

  if (password_field.value || confirmation_field.value) {
    requireField(password_field, true);
    requireField(confirmation_field, true);
    update_button.disabled = false
  } else {
    requireField(password_field, false);
    requireField(confirmation_field, false);
    update_button = true
  }
}

function requireField(field, bool) {
  if (bool) {
    field.setAttribute('required', bool);
  } else {
    field.removeAttribute('required');
  }
}
