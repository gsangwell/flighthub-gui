class NetworkController < ApplicationController

  delegate :network_variables,
           :network_setup,
           to: 'Rails.application.config'

  def index
    file_lines = file_data
    @internal_vars = file_lines.select { |l| l.include? "INTERNAL" }
    @external_vars = file_lines.select { |l| l.include? "EXTERNAL" }
  end

  def edit
    tmp = Tempfile.new("temp_vars")

    file_data.each do |line|
      if line.include?("INTERNAL") || line.include?("EXTERNAL")
        content = line.split("export")[1].split("=")
        variable = content[0]
        tail = content[1].split('"')[2]

        line = "export#{variable}=\"#{network_params[variable]}\"#{tail}"
      end

      tmp << line
    end

    tmp.close

    if `cp --no-preserve=mode,ownership #{tmp.path} #{Rails.application.config.network_variables}`
      flash[:success] = 'Network configuration successfully modified'
    else
      flash[:danger] = 'Encountered an error whilst trying to modify the network configuration'
    end

    tmp.delete

    redirect_to network_path
  end

  private

  def network_params
    params[:network]
  end

  def file_data
    IO.binread(Rails.application.config.network_variables).lines.map
  end
end
