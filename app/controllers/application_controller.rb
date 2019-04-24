class ApplicationController < ActionController::Base
  include Clearance::Controller

  require 'commonmarker'
  require 'open3'

  helper_method :bolt_on_enabled
  helper_method :format_markdown

  def authenticate(params)
    User.authenticate(
      params[:session][:username],
      params[:session][:password]
    )
  end

  def run_shell_command(command)
    system(command, out: File::NULL)
  end

  def run_global_script(command, *args)
    out, err, sta = Open3.capture3(
      "bash #{ENV['ENTRYPOINT']} #{command} #{args.join(' ')}"
    )

    return { output: out, error: err, status: sta }
  end

  def bolt_on_enabled(name)
    bolt_on = BoltOn.find_by(name: name)
    bolt_on.nil? ? true : bolt_on.enabled?
  end

  def redirect_unless_bolt_on(bolt_on)
    redirect_to root_path unless bolt_on_enabled(bolt_on)
  end

  def format_markdown(text)
    MarkdownRenderer.render(text)
  end
end
