$(document).on("turbolinks:load",function () {

  jQuery.validator.addMethod("username", function(value, element) {
    return this.optional(element) || /^[a-z_]([a-z0-9_-]{0,31}|[a-z0-9_-]{0,30}\$)$/i.test(value);
  }, "Please enter a valid username.");

  jQuery.validator.addMethod("ip", function(value, element) {
    return this.optional(element) || /^((25[0-5]|(2[0-4]|1\d|[1-9]|)\d)(\.(?!$)|$)){4}$/i.test(value);
  }, "Please enter a valid ipv4 address.");

  jQuery.validator.addMethod("netmask", function(value, element) {
    return this.optional(element) || /^((128|192|224|240|248|252|254)\.0\.0\.0)|(255\.(((0|128|192|224|240|248|252|254)\.0\.0)|(255\.(((0|128|192|224|240|248|252|254)\.0)|255\.(0|128|192|224|240|248|252|254)))))$/i.test(value);
  }, "Please enter a valid netmask.");

  $("#setup_user").validate({
    rules: {
      "setup_user[name]": { required: true },
      "setup_user[username]": { required: true, username: true },
      "setup_user[password]": { required: true, minlength: 6 },
      "setup_user[password_confirmation]": { required: true, equalTo: "#setup_user_password" }
    },
    messages: {
      "setup_user[name]": { required: "Please enter your name." },
      "setup_user[username]": { required: "Please enter a username." },
      "setup_user[password_confirmation]": { equalTo: "Please enter the same password twice." }
    }
  });

  $("#setup_network").validate({
    rules: {
      "setup_network[ipv4]": { required: true, ip: true },
      "setup_network[netmask]": { required: true, netmask: true} ,
      "setup_network[gateway]": { required: false, ip: { depends: isFieldNotEmpty("setup_network_gateway") } }
    },
    messages: {
      "setup_network[ipv4]": { required: "Please enter an ipv4 address." },
      "setup_network[netmask]": { required: "Please enter a netmask." }
    }
  });

});

function isFieldNotEmpty(field) {
    return $("#"+field).val().length > 0;
}
