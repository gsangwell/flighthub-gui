// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery3
//= require jquery.validate
//= require jquery.validate.additional-methods
//= require rails-ujs
//= require activestorage
//= require popper
//= require bootstrap
//= require turbolinks
//= require_tree .
//= require textarea-autosize.js
//= require react.min.js
//= require react-dom.min.js
//= require flight-tutorials-client.min.js

$(document).ready(function() {
    // show the alert
    $(".alert").first().delay(4000).slideUp(500, function () {
       $(this).remove(); 
    });
});
