class MonitorsController < ApplicationController
  before_filter :authenticate_user!
  def application
  end

  def database
  end

  def web
  end

end
