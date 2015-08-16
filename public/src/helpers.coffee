# simple helper funcitons
# these functions are not isomorphic (they will not work on the backend)

$ = require 'jquery'

exports.getUserFromDom = ->
  target = $('#cq-target')
  user = target.data()

  # isAdmin is a bool, so it shows up funny as a data-* attribute
  user.isAdmin = 'isAdmin' of user

  user

