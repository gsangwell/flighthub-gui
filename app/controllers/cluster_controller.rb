class ClusterController < ApplicationController
  require 'commonmarker'

  def index
    #BoltOns
    @vpn = bolt_on_enabled('VPN')

    @content = appliance_information
    @active = vpn_status
  end

  def restart
    run_shell_command("shutdown -r +1 'Reboot requested via web interface'")
  end

  def stop
    run_shell_command("shutdown -h +1 'Shutdown requested via web interface'")
  end

  private

  def appliance_information
    file = Rails.application.config.appliance_information
    file_data = IO.binread(file) if File.exist? file

    if file_data
      CommonMarker.render_html(file_data, :DEFAULT, [:table])
    end
  end

  def vpn_status
    run_shell_command("systemctl is-active --quiet openvpn@flightcenter")
  end
end
