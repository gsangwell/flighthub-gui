class ClusterController < ApplicationController
  require 'json'

  def index
    @info = run_appliance_menu_cmd('infoInst')[:output]
    @network = run_appliance_menu_cmd('inetStat')[:output]

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

  def enable_eng_mode
    if run_appliance_menu_cmd('engMode')[:status].success?
      flash[:success] = 'Engineering Mode has been enabled for 1 hour'
    else
      flash[:danger] = 'Encountered an error whilst trying to enable Engineering Mode'
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
