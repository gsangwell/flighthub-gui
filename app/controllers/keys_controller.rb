class KeysController < ApplicationController
  require 'fileutils'
  require 'tempfile'

  def index
    @ssh_keys = file_data
  end

  def delete
    tmp = Tempfile.new("temp_keys")

    file_data.each { |l| tmp << l unless l == params[:key] }
    tmp.close

    if FileUtils.mv(tmp.path, 'tmp/keys')
      flash[:success] = 'SSH key successfully removed'
    else
      flash[:danger] = 'Encountered an error whilst trying to remove the SSH key'
    end

    redirect_to ssh_path
  end

  private

  def file_data
    data ||= IO.binread("tmp/keys").lines.map(&:chomp)
  end
end
