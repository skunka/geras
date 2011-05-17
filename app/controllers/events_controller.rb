class EventsController < ApplicationController
  
	active_scaffold :event do |config|
		config.columns.exclude :event_series
	end
  
  
  def index
    
  end
  
  
  def get_events
    @events = Event.find(:all, :conditions => ["starttime >= '#{Time.at(params['start'].to_i).to_formatted_s(:db)}' and endtime <= '#{Time.at(params['end'].to_i).to_formatted_s(:db)}'"] )
    events = [] 
    @events.each do |event|
      events << {:id => event.id, :title => event.title, :description => event.description || "Some cool description here...", :start => "#{event.starttime.iso8601}", :end => "#{event.endtime.iso8601}", :allDay => event.all_day, :recurring => (event.event_series_id)? true: false}
    end
    render :text => events.to_json
  end
  
  
  
  def move
    @event = Event.find_by_id params[:id]
    if @event
      @event.starttime = (params[:minute_delta].to_i).minutes.from_now((params[:day_delta].to_i).days.from_now(@event.starttime))
      @event.endtime = (params[:minute_delta].to_i).minutes.from_now((params[:day_delta].to_i).days.from_now(@event.endtime))
      @event.all_day = params[:all_day]
      @event.save
    end
  end
  
  
  def resize
    @event = Event.find_by_id params[:id]
    if @event
      @event.endtime = (params[:minute_delta].to_i).minutes.from_now((params[:day_delta].to_i).days.from_now(@event.endtime))
      @event.save
    end    
  end
  
  def edit
    @event = Event.find_by_id(params[:id])
  end
  
  def update
    @event = Event.find_by_id(params[:event][:id])
    if params[:event][:commit_button] == "Update All Occurrence"
      @events = @event.event_series.events #.find(:all, :conditions => ["starttime > '#{@event.starttime.to_formatted_s(:db)}' "])
      @event.update_events(@events, params[:event])
    elsif params[:event][:commit_button] == "Update All Following Occurrence"
      @events = @event.event_series.events.find(:all, :conditions => ["starttime > '#{@event.starttime.to_formatted_s(:db)}' "])
      @event.update_events(@events, params[:event])
    else
      @event.attributes = params[:event]
      @event.save
    end

    render :update do |page|
      page<<"$('#calendar').fullCalendar( 'refetchEvents' )"
      page<<"$('#desc_dialog').dialog('destroy')" 
    end
    
  end  
  
  def destroy
    @event = Event.find_by_id(params[:id])
    if params[:delete_all] == 'true'
      @event.event_series.destroy
    elsif params[:delete_all] == 'future'
      @events = @event.event_series.events.find(:all, :conditions => ["starttime > '#{@event.starttime.to_formatted_s(:db)}' "])
      @event.event_series.events.delete(@events)
    else
      @event.destroy
    end
    
    render :update do |page|
      page<<"$('#calendar').fullCalendar( 'refetchEvents' )"
      page<<"$('#desc_dialog').dialog('destroy')" 
    end
    
  end
  
    def acounting
    @format = ("iso_date").to_sym


    start_d, end_d = params[:start_d] || Time.now, params[:end_d] || Time.now

    if current_user.admin?
      @users = User.find(:all)
      @companies = Company.find(:all)
    elsif current_user.role? :admin
      @users = User.find_all_by_company_id current_user.company.id
      @companies = Company.find(:first, :conditions => {:company_id => current_user.company.id})
    elsif current_user.role? :company
      @users = User.find_all_by_company_id current_user.company.id
      @companies = Company.find(:first, :conditions => {:company_id => current_user.company.id})
    else
      @users = [current_user]
      @companies = current_user.company_id? ? [  current_user.company_id ] : []
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
