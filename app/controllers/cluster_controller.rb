class ClusterController < ApplicationController
  require 'commonmarker'

  def index
    file_data = IO.binread(Rails.application.config.appliance_information)
    @content = CommonMarker.render_html(file_data, :DEFAULT, [:table])
  end
end
