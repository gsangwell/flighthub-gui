class NetworkController < ApplicationController

  def index
    @network_interfaces = run_appliance_menu_cmd('networkAllInterfaceDetails')[:output]['interfaces']
    @firewall_zones = run_appliance_menu_cmd('firewallAllZoneDetails')[:output]['zones']
  end

  private

end
