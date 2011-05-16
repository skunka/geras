class CalendarController < ApplicationController
  before_filter :authenticate_user!
  def index   
    @month = (params[:month] || (Time.zone || Time).now.month).to_i
    @year = (params[:year] || (Time.zone || Time).now.year).to_i
    @day = (params[:day] || (Time.zone || Time).now.day).to_i

    @shown_month = Date.civil(@year, @month, @day)
    
    start_d, end_d = Event.get_start_and_end_dates(@shown_month)  #
    if current_user.admin?
      @users = User.find(:all)
    elsif current_user.role? :admin
      @users = User.find_all_by_company_id current_user.company.id

    elsif current_user.role? :company
      @users = User.find_all_by_company_id current_user.company.id
    else
      @users = current_user
    end
    @events = Event.events_for_date_range(start_d,end_d, :conditions => ["events.user_id in (?)", @users])

    @event_strips = Event.event_strips_for_month(@shown_month, 1)

  end
  
  def day
    @month = (params[:month] || (Time.zone || Time).now.month).to_i
    @year = (params[:year] || (Time.zone || Time).now.year).to_i
    @day = (params[:day] || (Time.zone || Time).now.day).to_i
    
    @shown_month = Date.civil(@year, @month, @day)
    
    start_d, end_d = Event.get_start_and_end_dates(@shown_month)  #
    if current_user.admin?
      users = User.find(:all)
    elsif current_user.role? :admin
      users = User.find(:all, :include => :companies, :conditions => { "companies_users.company_id" => current_user.companies})

    elsif current_user.role? :company
      users = User.find(:all, :include => :companies, :conditions => { "companies_users.company_id" => current_user.companies})

    else
      users = current_user
    end
    @events = Event.find(:all, :conditions => ["events.user_id in (?) and ((? between DATE(events.start_at) and DATE(events.end_at)) or (? between DATE(events.start_at) and DATE(events.end_at)))", users, @shown_month,@shown_month])
    @event_strips = Event.create_event_strips(start_d,end_d,@events)
  end

  def acounting
    @format = ("iso_date").to_sym


    start_d, end_d = params[:start_d] || Time.now, params[:end_d] || Time.now

    if current_user.admin?
      @users = User.find(:all)
      @companies = Company.find(:all)
    elsif current_user.role? :admin
      @users = User.find(:all, :include => :companies, :conditions => { "companies_users.company_id" => current_user.companies})
      @companies = User.companies
    elsif current_user.role? :company
      @users = User.find(:all, :include => :companies, :conditions => { "companies_users.company_id" => current_user.companies})
      @companies = User.companies
    else
      @users = [current_user]
      @companies = current_user.companies? ? [  current_user.companies ] : []
    end

    cond = [" 1=1"]

    if params[:Vartotojai]
      
      cond[0] << " AND user_id in (?)"
      cond << params[:Vartotojai]
    end
    if params[:Kompanijos]
      cond[0] << " AND user_id in (?)"
      cond << User.find(:all, :conditions => {:company_id => params[:Kompanijos]})
    end
    if params[:start_d]
      if params[:end_d]
        cond[0] << " and ( DATE(events.end_at) >= ? and DATE(events.start_at) <= ? )"
        cond << params[:start_d] << params[:end_d]
      else
        cond[0] << " and (? between DATE(events.start_at) and DATE(events.end_at)) or (? between DATE(events.start_at) and DATE(events.end_at))"
        cond << params[:start_d] << params[:start_d]
      end

    end


    
    @events = Event.find(:all, :conditions => cond)

  end

end
