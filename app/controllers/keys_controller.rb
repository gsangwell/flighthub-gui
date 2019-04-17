class KeysController < ApplicationController
  require 'fileutils'
  require 'tempfile'

  def index
    @ssh_keys = file_data
  end

  def create
    if run_global_script(ENV['SSH_ADD'], Rails.application.config.ssh_keys, new_key)[2].success?
      flash[:success] = 'SSH key successfully added'
    else
      flash[:danger] = 'Encountered an error whilst trying to add the SSH key'
    end

    redirect_to ssh_path
  end

  def delete
    if run_global_script(ENV['SSH_REMOVE'], Rails.application.config.ssh_keys, "'#{params[:key]}'")[2].success?
      flash[:success] = 'SSH key successfully removed'
    else
      flash[:danger] = 'Encountered an error whilst trying to remove the SSH key'
    end

    redirect_to ssh_path
  end

  private

  def file_data
    run_global_script(ENV['SSH_GET'], Rails.application.config.ssh_keys)[0].lines.map
  end

  def new_key
    "'#{params[:new_key][:key]}'"
  end
end
