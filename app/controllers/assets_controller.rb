class AssetsController < ApplicationController
  require 'open3'

  def index
    redirect_unless_bolt_on('Assets')
    cmd = "flight inventory list"
    if params[:filter_on] and params[:filter_arg]
      cmd = cmd + " --#{params[:filter_on]} #{params[:filter_arg]}"
    end
    @assets = {}
    assets_list = ''
    Bundler.with_clean_env do
      #This ';' is neccessary to force shell execution
      #See here: https://stackoverflow.com/a/26040994/6257573
      assets_list = Open3.capture3(cmd + ";")[0]
    end
    assets_by_type = assets_list.split("\n#")
    assets_by_type.each do |type_list|
      next if type_list.empty?
      type_list = type_list.split("\n")
      @assets[type_list.shift] = type_list
    end
  end

  def single_asset
    redirect_unless_bolt_on('Assets')
    @name = params[:name]
    #TODO change command when the syntax loses the `show`
    # (flight inventory issue #117)
    #TODO `-f headnode` when that is implemented/for production
    cmd = "flight inventory show document #{@name};"
    Bundler.with_clean_env do
      @asset_data = Open3.capture3(cmd)[0]
    end

    @content = render_as_markdown(@asset_data)
  end

  def asset_params
    params.require(:asset).permit(:filter_on, :filter_arg)
  end
end
