class VpnController < ApplicationController
  require 'json'

  def index
    @slots = run_appliance_menu_cmd('vpnStatus')[:output]["vpns"]

    @slots.each do |slot, config|
      config["script"] = run_appliance_menu_cmd(
        'vpnViewClientScript',
        JSON.generate({ "vpn": slot })
      )[:output][slot]
    end

    run_appliance_menu_cmd('vpnSlotsAvail')[:output]["slots"].each do |slot|
      @slots[slot] = {}
    end
  end

  def assign
    vpn_slot_data = JSON.generate(
      {
        "vpn": vpn_params[:slot],
        "clientname": vpn_params[:client_name]
      }
    )

    if run_appliance_menu_cmd('vpnAssign', vpn_slot_data)[:output]["status"]
      flash[:success] = "Assigned #{vpn_params[:slot]} to #{vpn_params[:client_name]}"
    else
      flash[:danger] = 'Encountered an error whilst trying to assign the slot'
    end

    redirect_to vpn_path
  end

  def generate_password
    slot = params[:slot]
    cmd = run_appliance_menu_cmd('vpnGeneratePasswd', JSON.generate({"vpn": slot}))

    if cmd[:output]["status"]
      render plain: cmd[:output][slot]
    end
  end

  private

  def vpn_params
    params[:vpn]
  end
end
