class UsersController < ApplicationController
  before_filter :get_user, :only => [:index,:edit]
  before_filter :accessible_roles, :only => [:new, :edit, :show, :update, :create]
  load_and_authorize_resource :only => [:show,:new,:destroy,:edit,:update]
  
  active_scaffold :user do |config|
	
	config.label = 'Vartotojai' 
	config.columns.exclude :events
    config.columns[:roles].form_ui = :select
	
  end

  def conditions_for_collection
    if current_user.admin?
      "1=1"
    elsif current_user.role? :admin
      "1=1"
    elsif current_user.role? :company
      users = User.find_all_by_company_id current_user.company_id
      ["users.id in (?)", users]
    else
      ["users.id=?", current_user]
    end
  end
  
end