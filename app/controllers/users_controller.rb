class UsersController < ApplicationController
  before_filter :get_user, :only => [:index,:edit]
  before_filter :accessible_roles, :only => [:new, :edit, :show, :update, :create]
  load_and_authorize_resource :only => [:show,:new,:destroy,:edit,:update]
  
  active_scaffold :user do |config|

  end

  def conditions_for_collection
    if current_user.admin?
      "1=1"
    elsif current_user.role? :admin
      "1=1"
    elsif current_user.role? :company
      users =  User.find(:all, :include => :companies, :conditions => { "companies_users.company_id" => current_user.companies})

    else
      ["users.id=?", current_user]
    end
  end
  
end