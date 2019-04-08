class AssetsController < ApplicationController
  require 'open3'

  def index
    redirect_unless_bolt_on('Assets')
    @assets = {}
    assets_list = ''
    Bundler.with_clean_env do
      #This ';' is neccessary to force shell execution
      #See here: https://stackoverflow.com/a/26040994/6257573
      assets_list = Open3.capture3("flight inventory list;")[0]
    end
    assets_by_type = assets_list.split("\n#")
    assets_by_type.each do |type_list|
      next if type_list.empty?
      type_list = type_list.split("\n")
      @assets[type_list.shift] = type_list
    end
  end
end
