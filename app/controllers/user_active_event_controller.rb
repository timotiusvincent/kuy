class UserActiveEventController < ApplicationController
  def index
    if params[:user_id].present?
      @active_events = UserActiveEvent.all
      @active_events = @active_events.filter_by_user(params[:user_id])
      datetime_now = DateTime.now()
      @event_ids = Array.new
      @active_events.each do |active_event|
        event_id = active_event[:event_id]
        event = Event.find(event_id)
        start_time = event[:start_time]
        if datetime_now < start_time
          @event_ids.push(event_id)
        end
      end
    end
    render json: {
      status: 'SUCCESS',
      message: 'Scheduled Events Loaded',
      data: @event_id},
      status: :ok
  end
end
