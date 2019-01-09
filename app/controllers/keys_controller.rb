class KeysController < ApplicationController
  def index
    @ssh_keys = IO.binread("/path/to/ssh/keys")
  end
end
