class KeysController < ApplicationController
  require 'fileutils'
  require 'tempfile'

  delegate :ssh_keys,
           to: 'Rails.application.config'

  def index
    @ssh_keys = file_data
  end

  def create
    if run_global_script(ENV['SSH_ADD'], ssh_keys, new_key)[:status].success?
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
    run_global_script(ENV['SSH_GET'], ssh_keys)[:output].lines.map
  end

  def new_key
    "'#{params[:new_key][:key]}'"
  end
end
