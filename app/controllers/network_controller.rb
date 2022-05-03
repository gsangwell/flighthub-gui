class NetworkController < ApplicationController
  before_action -> { redirect_unless_bolt_on("Network") }

  def index
    platform_type = run_appliance_menu_cmd('infoInst')[:output]['type']
    @metal_platform = (platform_type == "metal")
    @network_interfaces = run_appliance_menu_cmd('networkAllInterfaceDetails')[:output]['interfaces']
    @firewall_zones = run_appliance_menu_cmd('firewallAllZoneDetails')[:output]['zones']
  end

  def configure

    rjson = JSON.generate(
    {
         "network":params['network']['name'],
         "settings": {
             "static":"true",
             "ipv4": params['network']['ipv4'],
             "netmask": params['network']['netmask'],
             "gateway": params['network']['gateway'] != "" ? params['network']['gateway'] : nil
         }
    }
    )

    if run_appliance_menu_cmd('networkReconfigure', rjson)[:output]['status']
      flash[:success] = 'Network configuration saved - please restart Alces Hub'
    else
     flash[:danger] = 'Encountered an error whilst saving network configuration.'
    end

    redirect_to network_path
  end

  private

end
