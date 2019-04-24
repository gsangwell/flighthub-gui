class AssetsController < ApplicationController
  require 'open3'

  def index
    redirect_unless_bolt_on('Assets')
    cmd = "flight inventory list"
    if params[:filter_on] and !params[:filter_arg].blank?
      cmd = cmd + " --#{params[:filter_on]} #{params[:filter_arg].downcase}"
    end
    @assets = get_assets(cmd)
  end

  def single_asset
    redirect_unless_bolt_on('Assets')
    @name = params[:name]
    cmd = "flight inventory show #{@name} -f diagram-markdown;"
    @asset_data = execute(cmd)
    img_regex = /<img\ssrc=.+>/
    if @asset_data.match?(img_regex)
      parts = @asset_data.partition(img_regex)

      asset_list = []
      get_assets.each do |key, value|
        asset_list.concat(value)
      end

      parts[0] = format_markdown(parts[0])
      parts[2] = format_markdown(parts[2])

      [parts[0], parts[2]].each do |p|
        p.scan(/[\w-]+/).each do |w|
          if asset_list.include?(w)
            p[w] = view_context.link_to(w, assets_path + '/' + w)
          end
        end
      end

      @content = parts.reduce{ |a, b| a + b }
    else
      @content = format_markdown(@asset_data)
    end
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
