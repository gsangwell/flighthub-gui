class KeysController < ApplicationController
  require 'fileutils'
  require 'tempfile'

  def index
    @ssh_keys = file_data
  end

  def create
    tmp = Tempfile.new("temp_keys")

    file_data.each { |l| tmp << l }
    tmp.write "#{new_key}\n"
    tmp.close

    if `cp --no-preserve=mode,ownership #{tmp.path} #{Rails.application.config.ssh_keys}`
      flash[:success] = 'SSH key successfully added'
    else
      flash[:danger] = 'Encountered an error whilst trying to add the SSH key'
    end

    tmp.delete

    redirect_to ssh_path
  end

  def delete
    tmp = Tempfile.new("temp_keys")

    file_data.each { |l| tmp << l unless l == params[:key] }
    tmp.close

    if `cp --no-preserve=mode,ownership #{tmp.path} #{Rails.application.config.ssh_keys}`
      flash[:success] = 'SSH key successfully removed'
    else
      flash[:danger] = 'Encountered an error whilst trying to remove the SSH key'
    end

    tmp.delete

    redirect_to ssh_path
  end

  private

  def file_data
    data ||= IO.binread(Rails.application.config.ssh_keys).lines.map
  end

  def new_key
    params[:new_key][:key]
  end
end
