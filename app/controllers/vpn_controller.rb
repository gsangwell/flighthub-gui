class VpnController < ApplicationController
  def index
  end

  def start
    if system("systemctl start openvpn@flightcenter")
      flash[:success] = 'VPN started'
    else
      flash[:danger] = 'Enountered an error whilst trying to start the VPN'
    end
  end

  def stop
    if system("systemctl stop openvpn@flightcenter")
      flash[:success] = 'VPN stopped'
    else
      flash[:danger] = 'Encountered an error whilst trying to stop the VPN'
    end
  end
end
