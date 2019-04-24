class NetworkController < ApplicationController

  delegate :network_variables,
           to: 'Rails.application.config'

  def index
    @network_vars = network_get_output
    @networks = network_show_output
  end

  def edit
    tmp = Tempfile.new("temp_vars")

    if File.exist? network_variables
      file_data.each do |line|
        if line.include?("INTERNAL") || line.include?("EXTERNAL")
          content = line.split("=")
          variable = content[0].remove("export ")
          original_value = content[1].split('"')[1]

          if original_value.empty?
            line = line.insert(line.index('"') + 1, network_params[variable])
          else
            line = line.sub original_value, network_params[variable]
          end
        end

        tmp << line
      end

      tmp.close

      if run_shell_command("cp --no-preserve=mode,ownership #{tmp.path} #{network_variables}")
        if run_global_script(ENV['NETWORK_SET'])[:status].success?
          flash[:success] = 'Network configuration successfully modified'
        else
          flash[:danger] = 'Encountered an error whilst trying to run the setup script'
        end
      else
        flash[:danger] = 'Encountered an error whilst trying to modify the network configuration'
      end

      tmp.delete
    else
      flash[:danger] = 'No network variables file defined'
    end

    redirect_to network_path
  end

  def add_ssh_service
    if run_global_script(ENV['SSH_ENABLE'])[:status].success?
      flash[:success] = 'SSH enabled on the external interface'
    else
      flash[:danger] = 'Encountered an error whilst trying to enable SSH'
    end

    redirect_to network_path
  end

  def remove_ssh_service
    if run_global_script(ENV['SSH_DISABLE'])[:status].success?
      flash[:success] = 'SSH disabled on the external interface'
    else
      flash[:danger] = 'Encountered an error whilst trying to disable SSH'
    end

    redirect_to network_path
  end

  private

  def network_params
    params[:network]
  end

  def network_get_output
    run_global_script(ENV['NETWORK_GET'])[:output].lines.map
  end

  def network_show_output
    run_global_script(ENV['NETWORK_SHOW'])[:output].split("\n\n")
      .map { |n| n.split("\n") }
  end

  def file_data
    IO.binread(network_variables).lines.map
  end
end
