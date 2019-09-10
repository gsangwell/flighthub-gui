function populateModifyModal() {
  $('#modifyModal').on('show.bs.modal', function(e) {
    var username = e.relatedTarget.dataset.username;

    $(e.currentTarget).find('input[name="user_modify[username]"]').val(username)
  });
}

document.addEventListener('turbolinks:load', populateModifyModal);
