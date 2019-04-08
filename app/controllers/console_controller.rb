class ConsoleController < ApplicationController
  before_action :check_bolt_on_is_enabled

  private

  def check_bolt_on_is_enabled
    redirect_to root_path unless bolt_on_enabled('Console')
  end
end
