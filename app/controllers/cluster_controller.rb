class ClusterController < ApplicationController
  require 'commonmarker'

  def index
    file_data = IO.binread("/path/to/file")
    @content = CommonMarker.render_html(file_data, :DEFAULT, [:table])
  end
end
