class VpnController < ApplicationController
  def index
    @slots = run_appliance_menu_cmd('vpnStatus')[:output]["vpns"]
    run_appliance_menu_cmd('vpnSlotsAvail')[:output]["slots"].each do |slot|
      @slots[slot] = {}
    end
  end

  def start
    return unless bolt_on_enabled('VPN')
    if run_global_script(ENV['VPN_START'])[:status].success?
      flash[:success] = 'VPN started'
    else
      flash[:danger] = 'Enountered an error whilst trying to start the VPN'
    end

    redirect_to cluster_path
  end

  def stop
    return unless bolt_on_enabled('VPN')
    if run_global_script(ENV['VPN_STOP'])[:status].success?
      flash[:success] = 'VPN stopped'
    else
      flash[:danger] = 'Encountered an error whilst trying to stop the VPN'
    end

    redirect_to cluster_path
  end

  def restart
    return unless bolt_on_enabled('VPN')
    if run_global_script(ENV['VPN_RESTART'])[:status].success?
      flash[:success] = 'VPN restarted'
    else
      flash[:danger] = 'Encountered an error whilst trying to restart the VPN'
    end

    redirect_to cluster_path
  end
end
