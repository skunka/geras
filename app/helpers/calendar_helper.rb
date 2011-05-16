module CalendarHelper
  def month_link(month_date)
    link_to(I18n.localize(month_date, :format => "%B"), {:month => month_date.month, :year => month_date.year})
  end
  
  # custom options for this calendar
  def event_calendar_opts
    {

      :year => @year,
      :month => @month,
      :abbrev => true,
      :first_day_of_week => 1, # See note below when setting this
      :show_today => true,
      :show_header => true,
      :month_name_text => @shown_month.strftime("%B %Y"),
      :previous_month_text => "<< " + month_link(@shown_month.prev_month),
      :next_month_text => month_link(@shown_month.next_month) + " >>",
      :event_strips => @event_strips,

      # it would be nice to have these in the CSS file
      # but they are needed to perform height calculations

      :use_all_day => true,
      :use_javascript => true,
      :link_to_day_action => "day"


    }
  end

  def event_calendar
    # args is an argument hash containing :event, :day, and :options
    calendar event_calendar_opts do |args|
      event, day = args[:event], args[:day]
      html = %(<a href="/events/#{event.id}" title="#{h(event.name)}">)
     # html << display_event_time(event, day)
      html << %(#{h(event.name)}</a>)
      html
    end
  end

  def display_event_time(event, day)
    time = event.start_at
    if !event.all_day and time.to_date == day
      t = I18n.localize(time, :format => "%l:%M%p")
      %(<span class="ec-event-time">#{t}</span>)
    else
      ""
    end
  end

end
