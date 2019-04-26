function changeIconOnClick() {
  $('#accordion h5 a').click(function(e){
    var card = $(e.target).closest('div.card');
    var img = $('i', card)[0];

    if (img.classList.contains('fa-plus')) {
      img.classList.remove('fa-plus');
      img.classList.add('fa-minus');
    } else {
      img.classList.remove('fa-minus');
      img.classList.add('fa-plus');
    }
  });
}

document.addEventListener('turbolinks:load', changeIconOnClick);
