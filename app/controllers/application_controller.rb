class ApplicationController < ActionController::Base
  include Clearance::Controller
  require 'open3'

  def authenticate(params)
    User.authenticate(
      params[:session][:username],
      params[:session][:password]
    )
  end

  # Deprecated and will be removed once run_global_script has been utilised
  def run_shell_command(command)
    system(command, out: File::NULL)
  end

  def run_global_script(command, *args)
    Open3.capture3("bash #{ENV['ENTRYPOINT']} #{command} #{args.join(' ')}")
  end

  def bolt_on_enabled(name)
    BoltOn.find_by(name: name).enabled?
  end
  helper_method :bolt_on_enabled
end
