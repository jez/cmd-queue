_      = require 'underscore'
models = require '../models'
util   = require '../public/src/util'

includeParams = [
    model: models.Spot
    include: [
      model: models.User
      as: 'Holder'
    ]
  ,
    model: models.User
    as: 'Owners'
]

exports.index = (req, res, next) ->
  # -- no params --

  # this is kind of an unfortunate query, but I'm not good enought at SQL nor
  # sequelize to be able to join all the queues and their lengths
  models.Queue.findAll
      include: includeParams
      order: 'Queue.displayName ASC'
    .then (queues) ->
      res.json queues

exports.show = (req, res, next) ->
  key = req.params.key

  models.Queue.findById key, include: includeParams
    .then (queue) ->
      res.json queue

exports.create = (req, res, next) ->
  queue =
    key:         req.body.key
    displayName: req.body.displayName
  user = req.user

  unless util.validateSlug queue.key
    ex = new Error 'Invalid key for queue'
    ex.status = 500
    ex.type = 'json-error'
    next ex

  models.Queue.create queue
    .then (queue) ->
      queue.addOwner user
    .then ->
      models.Queue.findById queue.key, include: includeParams
    .then (queue) ->
      res.location "/queues/#{queue.key}"
      res.status(201).json queue
    .error (err) ->
      ex = new Error 'Error creating queue'
      ex.status = 500
      ex.type = 'json-error'
      next ex

exports.destroy = (req, res, next) ->
  key    = req.params.key
  userId = req.user.id

  # Ideally we wouldn't have to make two SQL queries here :(
  models.Queue.findById key, include: includeParams[1]
    .then (queue) ->
      if util.isInOwners userId, queue.Owners
        models.Queue.destroy { where: { key: key }}
    .then (n) ->
      if n? and n > 0
        res.status(204).send null
      else
        res.status(404).send 'No queues matching search query.'
    .error (err) ->
      ex = new Error 'Error destroying queue'
      ex.status = 500
      ex.type = 'json-error'
      next ex

exports.modify = (req, res, next) ->
  key    = req.params.key
  owners = req.body.owners
  userId = req.user.id

  models.Queue.findById key
    .then (queue) ->
      if util.isInOwners userId, queue.getOwners()
        queue.addOwners owners
    .then ->
      models.Queue.findById queue.key, include: includeParams
    .then (queue) ->
      res.status(204).json queue
    .error (err) ->
      ex = new Error 'Error modifying queue'
      ex.status = 500
      ex.type = 'json-error'
      next ex

# non-RESTful endpoints

exports.join = (req, res, next) ->
  userId = req.user.id
  key    = req.params.key
  spot =
    QueueKey: key
    HolderId: userId

  models.Queue.findById key, include: includeParams[0]
    .then (queue) ->
      if not util.isInQueue(userId, queue.Spots)
        models.Spot.create spot
          .then (spot) ->
            models.Spot.findById spot.key, include: includeParams[0].include
          .then (spot) ->
            res.location "/api/spots/#{spot.key}"
            res.status(201).json spot
      else
        ex = new Error "You can't hold multiple spots in the same queue."
        ex.status = 409
        ex.type = 'json-error'
        next ex
    .error (err) ->
      ex = new Error 'Error joining queue'
      ex.status = 500
      ex.type = 'json-error'
      next ex

