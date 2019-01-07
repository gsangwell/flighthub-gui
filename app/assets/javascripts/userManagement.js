function populateModifyModal() {
  $('#ModifyModal').on('show.bs.modal', function(e) {
    var username = e.relatedTarget.dataset.username;
    var email = e.relatedTarget.dataset.email;
    var id = e.relatedTarget.dataset.id;

    $(e.currentTarget).find('input[name="user_modify[username]"]').val(username)
    $(e.currentTarget).find('input[name="user_modify[email]"]').val(email)
    $(e.currentTarget).find('input[name="user_modify[id]"]').val(id)
  });
}

document.addEventListener('turbolinks:load', populateModifyModal);
