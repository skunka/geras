class HomeController < ApplicationController
 before_filter :authenticate_user!, :except => [:index, :token]

  def index
  end

  def token
  end
end
