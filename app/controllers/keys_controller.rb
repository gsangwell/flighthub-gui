class KeysController < ApplicationController
  require 'fileutils'
  require 'tempfile'

  delegate :ssh_keys,
           to: 'Rails.application.config'

  def index
    @ssh_keys = file_data
    @users = run_appliance_menu_cmd('userGetList')[:output]["users"]
      .sort.map { |u| u.gsub(/\(.*?\)/, "") }
  end

  def create
    user_key_data = JSON.generate(
      {
        "user-name": key_params[:user],
        "key": key_params[:key]
      }
    )

    if run_appliance_menu_cmd('userSetKey', user_key_data)[:output]["status"]
      flash[:success] = 'SSH key successfully added'
    else
      flash[:danger] = 'Encountered an error whilst trying to add the SSH key'
    end

    redirect_to ssh_path
  end

  def delete
    if run_global_script(ENV['SSH_REMOVE'], ssh_keys, "'#{params[:key]}'")[:status].success?
      flash[:success] = 'SSH key successfully removed'
    else
      flash[:danger] = 'Encountered an error whilst trying to remove the SSH key'
    end

    redirect_to ssh_path
  end

  private

  def file_data
    if File.exist? ssh_keys
      run_global_script(ENV['SSH_GET'], ssh_keys)[:output].lines.map
    else
      "No SSH keys file defined"
    end
  end

  def key_params
    params[:new_key]
  end
end
