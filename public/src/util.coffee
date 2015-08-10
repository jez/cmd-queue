# simple utility functions

exports.queueCountToString = (count) ->
  switch count
    when 0 then 'No people in the queue'
    when 1 then '1 person in the queue'
    else "#{count} people in the queue"

exports.slugify = (string) ->
  string.toString().toLowerCase()
    .replace /\s+/g, '-'           # Replace spaces with -
    .replace /[^\w\-]+/g, ''       # Remove all non-word chars
    .replace /\-\-+/g, '-'         # Replace multiple - with single -
    .replace /^-+/, ''             # Trim - from start of string
    .replace /-+$/, ''             # Trim - from end of string

exports.validateSlug = (string) ->
  not string or
    ((!!string.match /^[A-Za-z0-9]+(?:[_-][A-Za-z0-9]+)*$/) and
    not (string.match /--/))

