# simple utility functions

exports.queueCountToString = (count) ->
  switch count
    when 0 then 'No people in the queue'
    when 1 then '1 person in the queue'
    else "#{count} people in the queue"

