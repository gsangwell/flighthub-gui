class ClusterController < ApplicationController
  require 'commonmarker'

  def index
    file_data = IO.binread(Rails.application.config.appliance_information)
    @content = CommonMarker.render_html(file_data, :DEFAULT, [:table])

    @active = vpn_status
  end

  private

  def vpn_status
    run_shell_command("systemctl is-active --quiet openvpn@flightcenter")
  end
end
