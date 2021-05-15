class EventCompleteJob < ApplicationJob
  queue_as :default

  def perform(event)
    # Do something later
    event['status'] = 2
  end
end
