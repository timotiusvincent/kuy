class EventsController < ApplicationController
  def index
    @events = Event.all
    @events = @events.filter_by_status(0) # show only waiting events
    @events = @events.filter_by_city(params[:city]) if params[:city].present?
    @events = @events.filter_by_place(params[:place_id]) if params[:place_id].present?
    render json: {
      status: 'SUCCESS',
      message: 'Loaded Events',
      data: @events},
      status: :ok
  end

  def show
    @event = Event.find(params[:id])
    render json: {
      status: 'SUCCESS',
      message: 'Loaded Event',
      data: @event},
      status: :ok
  end

  def create
    start_time = DateTime.parse(params[:start_time])
    end_time = DateTime.parse(params[:end_time])
    if !check_availability(start_time, end_time)
      render json: {
        status: 'ERROR',
        message: 'Time conflict with existing event',
        data: nil},
        status: :conflict
    end
    @event = Event.new(event_params)
    @event['start_time'] = start_time
    @event['end_time'] = end_time
    @event['participants_id'] = ''
    @event['participants_count'] = 1
    @event['status'] = 0
    if @event.save
      user_id = params[:host_id]
      @active_event = UserActiveEvent.new()
      @active_event[:user_id] = user_id
      @active_event[:event_id] = @event[:id]
      @active_event.save!
      EventCompleteJob.set(wait_until: @event['end_time']).perform_later(@event)
      render json: {
        status: 'SUCCESS',
        message: 'Event saved',
        data: @event},
        status: :created
    else
      render json: {
        status: 'ERROR',
        message: 'Event not saved',
        data: @event.errors},
        status: :unprocessable_entity
    end
  end

  def update
    start_time = DateTime.parse(params[:start_time])
    end_time = DateTime.parse(params[:end_time])
    if !check_availability(start_time, end_time)
      render json: {
        status: 'ERROR',
        message: 'Time conflict with existing event',
        data: @event.errors},
        status: :conflict
    end
    @event = Event.find(params[:id])
    participants = @event[:participants_id]
    max_participants = @event[:party_size]
    participants_count = @event[:participants_count]
    if participants_count == max_participants
      render json: {
        status: 'NOT UPDATED',
        message: 'Max participants reached',
        data: @event},
        status: :bad_request
    end
    @event[:participants_id] = participants + ', ' + params[:user_id]
    @event[:participants_count] = participants_count + 1
    if @event.save
      @active_event = UserActiveEvent.new()
      @active_event[:user_id] = params[:user_id]
      @active_event[:event_id] = params[:id]
      @active_event.save!
      render json: {
        status: 'SUCCESS',
        message: 'Updated Event',
        data: @event},
        status: :ok
    else
      render json: {
        status: 'ERROR',
        message: 'Event not updated',
        data: @event.errors},
        status: :unprocessable_entity
    end
  end

  private

  def event_params
    params.permit(:place_id, :host_id,
      :party_size, :city, :notes, :minimum_rating)
  end

  def check_availability(new_start, new_end)
    user_id = params[:host_id] if params[:host_id].present?
    user_id = params[:user_id] if params[:user_id].present?
    active_events = UserActiveEvent.all
    active_events = active_events.filter_by_user(user_id)

    active_events.each do |active_event|
      event_id = active_event[:event_id]
      event = Event.find(event_id)
      start_time = event[:start_time]
      end_time = event[:end_time]
      if new_end > start_time || new_start < end_time
        return false
      end
    end
    return true
  end
end
