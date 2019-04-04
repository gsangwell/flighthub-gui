function enableTerminal() {
  if (!($(".console").length > 0)) {
    return;
  }

  // FlightTutorials needs to be told the URL to the terminal server.
  // This obviously changes from one application to another, so Overware
  // will need to specify it.
  const socketIOUrl = "http://192.168.56.11:25288/pty";
  // And the socket IO path.  We should perhaps have FlightTutorials set
  // as the default.
  const socketIOPath = "/terminal-service/socket.io";
  // We need to grab the DOM node that FlightTutorials is to be mounted
  // into.  This must already be present in the DOM.
  const terminalContainer = document.querySelector('#flight-terminal-container');
  // The height is calculated as:
  //   100% of the viewport height
  //   - 75px for the navbar
  //   - ( 38 * 2 )px for the title and introductory text
  //   - 1em for the terminal's bottom padding
  //   - 36px for the session history button
  //   - 1em to avoid pushing the session history button to the very bottom.
  const terminalHeight = "calc( 100vh - 75px - ( 38px * 2 ) - 1em - 36px - 1em )";
  // We're not performing any authentication / authorisation in this
  // example.  If we were we would include the credentials here perhaps a
  // token of some sort.  The terminal server backend would then need to
  // use those credentials to auth the request.
  const auth = {};
  // Any environment variables we want set in the process that runs the
  // backend terminal.  We need to not only specify them here, but also
  // configure the SSH command ran by the terminal server and configure
  // the SSH server.
  const env = {};

  const params = {
      auth: auth,
      env: env,
      socketIOPath: socketIOPath,
      socketIOUrl: socketIOUrl,
      terminalHeight: terminalHeight,
  };
  const e = React.createElement;
  ReactDOM.render(e(flight_tutorials.SimpleTerminal, params), terminalContainer);
}

document.addEventListener('turbolinks:load', enableTerminal)
