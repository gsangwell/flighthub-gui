class SetupController < ApplicationController
  require 'fileutils'

  def index
    @setup_wizard = true
    @dir = File.expand_path(File.dirname(__FILE__))
  end

  def start
    if cookies.encrypted[:setup_stage].nil?
      cookies.encrypted[:setup_stage] = "user"
    end

    stage = cookies.encrypted[:setup_stage]
    path = eval("setup_#{stage}_path")
    redirect_to path 
  end

  def user
    #ensureStage("user")
  end

  def createUser
    user_params = params[:setup_user]
    
    if doCheckExistingUser(user_params[:username])
      flash[:danger] = 'Username already exists - please try again.'
      redirect_to setup_user_path
      return
    end

    if doCreateUser(user_params)
      flash[:success] = 'Created initial user' 
    else
      flash[:danger] = 'Error creating user'
      redirect_to setup_user_path
      return
    end

    if doSetPasswd(user_params)
      cookies.encrypted[:setup_stage] = "network"
      redirect_to setup_network_path
    else
      flash[:danger] = 'Error setting user password'
      redirect_to setup_user_path
      return
    end
  end

  def network
    #ensureStage("network")

    @init_network = run_appliance_menu_cmd('networkInterfaceList')[:output]['interfaces'].first
  end

  def configureNetwork
    network_params = params[:setup_network]

    if doConfigureNetwork(network_params)
      flash[:success] = 'Network configuration saved.'
      cookies.encrypted[:setup_stage] = "https"
      redirect_to setup_finish_path
      return
    else
     flash[:danger] = 'Encountered an error whilst saving network configuration.'
     redirect_to setup_network_path
     return
    end
  end

  def finish
    #ensureStage("finish")
  end

  def doFinish
    BoltOn.find_by(name: "Setup").update(enabled: false)
    cmd = run_appliance_menu_cmd('reboot', JSON.generate({ "reboot": true }))
    
    if cmd[:output]["status"]
      flash[:success] = 'Restarting - this will take several minutes.'
    else
      flash[:danger] = 'Encountered an error whilst trying to restart the machine'
    end
    
    redirect_to root_path
  end

  def ensureStage(stage)
    current_stage = cookies.encrypted[:setup_stage]

    if current_stage != stage
      path = eval("setup_#{current_stage}_path")
      redirect_to path
    end
  end

  def doCheckExistingUser(user)
    return run_appliance_menu_cmd('userGetList')[:output]["users"].include?(user)
  end

  def doCreateUser(user_params)

    user_json = JSON.generate(
      {
        "user-name": user_params[:username],
        "full-name": user_params[:name]
        }
    )

    return run_appliance_menu_cmd('userCreate', user_json)[:output]['status']
  end

  def doSetPasswd(user_params)
    password_json = JSON.generate(
      {
        "user-name": user_params[:username],
        "passwd": user_params[:password].crypt(
          '$6$' + SecureRandom.random_number(36 ** 8).to_s(36)
        )
      }
    )

    return run_appliance_menu_cmd('userSetPasswd', password_json)[:output]["status"]
  end

  def doConfigureNetwork(network_params)

    net_name = run_appliance_menu_cmd('networkInterfaceList')[:output]['interfaces'].first

    rjson = JSON.generate(
      {
         "network":net_name,
         "settings": {
             "static":"true",
             "ipv4": network_params['ipv4'],
             "netmask": network_params['netmask'],
             "gateway": network_params['gateway'] != "" ? network_params['gateway'] : nil
         }
      }
    )

    return run_appliance_menu_cmd('networkReconfigure', rjson)[:output]['status']
  end
end
