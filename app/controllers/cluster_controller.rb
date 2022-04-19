class ClusterController < ApplicationController
  require 'json'

  def index
    @info = run_appliance_menu_cmd('infoInst')[:output]
    @network = run_appliance_menu_cmd('inetStat')[:output]
    @remote_support_enabled = run_appliance_menu_cmd('supportStatus')[:output]['status']
    @remote_support_enabled_since = run_appliance_menu_cmd('supportEnabledSince')[:output]['enabled-since']
    @remote_support_ping = run_appliance_menu_cmd('supportPing')[:output]['status']

    @content = appliance_information
  end

  def restart
    cmd = run_appliance_menu_cmd('reboot', JSON.generate({ "reboot": true }))
    if cmd[:output]["status"]
      flash[:success] = 'Restarting machine'
    else
      flash[:danger] = 'Encountered an error whilst trying to restart the machine'
    end

    redirect_to cluster_path
  end

  def stop
    cmd = run_appliance_menu_cmd('shutdown', JSON.generate({ "shutdown": true }))
    if cmd[:output]["status"]
      flash[:success] = 'Stopping the machine'
    else
      flash[:danger] = 'Encountered an error whilst trying to stop the machine'
    end

    redirect_to cluster_path
  end

  def enable_remote_support
    if run_appliance_menu_cmd('supportEnable')[:status].success?
      flash[:success] = 'Alces Support Mode has been enabled.'
    else
      flash[:danger] = 'Encountered an error whilst trying to enable Alces Support Mode'
    end

    redirect_to cluster_path
  end

  def disable_remote_support
    if run_appliance_menu_cmd('supportDisable')[:status].success?
      flash[:success] = 'Alces Support Mode has been disabled'
    else
      flash[:danger] = 'Encountered an error whilst trying to disable Alces Support Mode'
    end

    redirect_to cluster_path
  end

  private

  def appliance_information
    file = Rails.application.config.appliance_information
    file_data = IO.binread(file) if File.exist? file

    format_markdown(file_data)
  end
end
