class KeysController < ApplicationController
  def index
    file_data = IO.binread("/path/to/ssh/keys")
    @ssh_keys = file_data.lines.map(&:chomp)
  end
end
