class ApplicationController < ActionController::Base
  include Clearance::Controller

  def authenticate(params)
    User.authenticate(
      params[:session][:username],
      params[:session][:password]
    )
  end

  def run_shell_command(command)
    system(command, out: File::NULL)
  end
end
