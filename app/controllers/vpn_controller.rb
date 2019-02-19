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
end
