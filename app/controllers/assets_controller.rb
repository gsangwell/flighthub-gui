class AssetsController < ApplicationController
  require 'open3'

  def index
    redirect_unless_bolt_on('Assets')

    cmd = "flight inventory list"

    if params[:filter_on]
      cmd = cmd + " --#{params[:filter_on]} #{params[:filter_arg].downcase}"
    end

    @assets = get_assets(cmd)
  end

  def single_asset
    redirect_unless_bolt_on('Assets')

    @name = params[:name]
    cmd = "flight inventory show #{@name} -f overware;"
    @asset_data = execute(cmd)
    @content = format_markdown(@asset_data)
  end

  def asset_params
    params.require(:asset).permit(:filter_on, :filter_arg)
  end

  private

  # currently just returns stdout, this may need to be altered
  def execute(cmd)
    #This ';' is neccessary to force shell execution
    #See here: https://stackoverflow.com/a/26040994/6257573
    cmd = cmd + ';' unless cmd.match(/;$/)
    Bundler.with_clean_env { Open3.capture3(cmd)[0] }
  end

  #TODO potentially implement caching to prevent unnecssarily re-executing
  # this command
  def get_assets(cmd = 'flight inventory list')
   assets_by_type = {}
   asset_type_list = execute(cmd).split("\n#")
   asset_type_list.each do |type_list|
     next if type_list.empty?
     type_list = type_list.split("\n")
     assets_by_type[type_list.shift] = type_list
   end
   assets_by_type
  end
end
