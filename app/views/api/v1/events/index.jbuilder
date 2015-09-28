@events.each do |event|
  json.partial! 'api/v1/shared/event', event: event
end
