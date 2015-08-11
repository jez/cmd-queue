# simple helper funcitons
# these functions are not isomorphic (they will not work on the backend)

$ = require 'jquery'

exports.getUserId = ->
  target = $('#cq-target')
  target.data 'userId'
