class ApplicationController < ActionController::Base
  require 'commonmarker'
  include Clearance::Controller
  require 'open3'

  helper_method :bolt_on_enabled

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

  def redirect_unless_bolt_on(bolt_on)
    redirect_to root_path unless bolt_on_enabled(bolt_on)
  end

  def render_as_markdown(html)
    CommonMarker.render_html(html, :DEFAULT, [:table])
  end
end
