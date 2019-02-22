class VpnController < ApplicationController
  def start
    return unless bolt_on_enabled('VPN')
    if run_shell_command("systemctl start openvpn@flightcenter")
      flash[:success] = 'VPN started'
    else
      flash[:danger] = 'Enountered an error whilst trying to start the VPN'
    end

    redirect_to cluster_path
  end

  def stop
    return unless bolt_on_enabled('VPN')
    if run_shell_command("systemctl stop openvpn@flightcenter")
      flash[:success] = 'VPN stopped'
    else
      flash[:danger] = 'Encountered an error whilst trying to stop the VPN'
    end

    redirect_to cluster_path
  end

  def restart
    return unless bolt_on_enabled('VPN')
    if run_shell_command("systemctl restart openvpn@flightcenter")
      flash[:success] = 'VPN restarted'
    else
      flash[:danger] = 'Encountered an error whilst trying to restart the VPN'
    end

    redirect_to cluster_path
  end
end
