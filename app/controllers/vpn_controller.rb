class VpnController < ApplicationController
  def index
    @slots = run_appliance_menu_cmd('vpnStatus')[:output]["vpns"]
    run_appliance_menu_cmd('vpnSlotsAvail')[:output]["slots"].each do |slot|
      @slots[slot] = {}
    end
  end
end
