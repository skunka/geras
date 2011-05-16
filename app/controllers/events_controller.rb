class EventsController < ApplicationController
  before_filter :get_user, :only => [:index,:new,:edit]
  before_filter :accessible_roles, :only => [:index, :new, :edit, :show, :update, :create]
  load_and_authorize_resource :only => [:show,:new,:destroy,:edit,:update]

  active_scaffold :event do |config|
    config.columns = [:id, :name, :description, :start_at, :end_at, :user]

#    config.columns[:phone_number].label = "Phone"

    config.create.columns.exclude :id
    config.update.columns.exclude :id
    config.columns[:user].form_ui = :select

  end

  def conditions_for_collection
    if current_user.admin?
      " 1=1"
    elsif current_user.role? :admin
      users = User.find_all_by_company_id current_user.company.id
      [" events.user_id in (?)", users]
    elsif current_user.role? :company
      users = User.find_all_by_company_id current_user.company.id
      [" events.user_id in (?)", users]
    else
      [" events.user_id=?", current_user]
    end
  end
  
end
