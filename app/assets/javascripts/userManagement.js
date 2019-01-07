function populateModifyModal() {
  $('#ModifyModal').on('show.bs.modal', function(e) {
    var username = e.relatedTarget.dataset.username;
    var email = e.relatedTarget.dataset.email;
    var id = e.relatedTarget.dataset.id;

    $(e.currentTarget).find('input[name="user_modify[username]"]').attr('placeholder', username)
    $(e.currentTarget).find('input[name="user_modify[email]"]').attr('placeholder', email)
    $(e.currentTarget).find('input[name="user_modify[id]"]').val(id)
  });
}

document.addEventListener('turbolinks:load', populateModifyModal);
