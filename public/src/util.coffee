# simple utility functions
# all the functions here should be isomorphic

_ = require 'underscore'

exports.queueCountToString = (count) ->
  switch count
    when 0 then 'No one in the queue'
    when 1 then '1 person in the queue'
    else "#{count} people in the queue"

exports.queueOwnersToString = (owners) ->
  n = owners.length
  if n < 1
    "owned by no one"
  if n == 1
    "owned by #{owners[0].displayName}"
  else if n > 1
    "owned by #{owners[0].displayName} and #{n - 1} others"

exports.slugify = (string) ->
  string.toString().toLowerCase()
    .replace /\s+/g, '-'           # Replace spaces with -
    .replace /[^\w\-]+/g, ''       # Remove all non-word chars
    .replace /\-\-+/g, '-'         # Replace multiple - with single -
    .replace /^-+/, ''             # Trim - from start of string
    .replace /-+$/, ''             # Trim - from end of string

exports.validateSlug = (string) ->
  string != 'api' and
  string != 'admin' and
  ((!!string.match /^[A-Za-z0-9]+(?:[_-][A-Za-z0-9]+)*$/) and
  not (string.match /--/))

# admins are owners of all queues and also 'hold' all spots
exports.isInOwners = (user, owners) ->
  user.isAdmin or !!_.find owners, ((owner) -> owner.id == user.id)

exports.holdsSpot = (user, spot) ->
  user.isAdmin or spot.HolderId == user.id

exports.isInQueue = (userId, spots) ->
  !!_.find spots, ((spot) -> spot.HolderId == userId)
