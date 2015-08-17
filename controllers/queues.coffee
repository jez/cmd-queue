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

module.exports = (io) ->
  # Keep track of which queue we're broadcasting data to
  io.on 'connection', (socket) ->
    socket.on 'enter', (queueKey) ->
      if socket.queueKey
        socket.leave socket.queueKey
      socket.queueKey = queueKey
      socket.join queueKey

  index: (req, res, next) ->
    # -- no params --

    # this is kind of an unfortunate query, but I'm not good enought at SQL nor
    # sequelize to be able to join all the queues and their lengths
    models.Queue.findAll
        include: includeParams
      .then (queues) ->
        res.json queues

  show: (req, res, next) ->
    key = req.params.key

    models.Queue.findById key, include: includeParams
      .then (queue) ->
        res.json queue

  create: (req, res, next) ->
    queue =
      key:         req.body.key
      displayName: req.body.displayName
    user = req.user

    if not (queue.key and util.validateSlug queue.key)
      ex = new Error "Invalid key for queue: <#{queue.key}>"
      ex.status = 400
      ex.type = 'json-error'
      next ex
      return

    models.Queue.findOrCreate where: queue
      .spread (queue, created) ->
        if created
          queue.addOwner user
        else
          ex = new Error "Queue for key <#{queue.key}> already exists"
          ex.status = 409
          ex.type = 'json-error'
          next ex
      .then ->
        models.Queue.findById queue.key, include: includeParams
      .then (queue) ->
        res.location "/api/queues/#{queue.key}"
        res.status(201).json queue
      .error (err) ->
        ex = new Error 'Error creating queue'
        ex.status = 500
        ex.type = 'json-error'
        next ex

  destroy: (req, res, next) ->
    key  = req.params.key
    user = req.user

    # Ideally we wouldn't have to make two SQL queries here :(
    models.Queue.findById key, include: includeParams[1]
      .then (queue) ->
        if util.isInOwners user, queue.Owners
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

  modify: (req, res, next) ->
    key    = req.params.key
    owners = req.body.owners
    user   = req.user

    models.Queue.findById key
      .then (queue) ->
        if util.isInOwners user, queue.getOwners()
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

  join: (req, res, next) ->
    user = req.user
    key  = req.params.key
    spot =
      QueueKey: key
      HolderId: user.id

    models.Queue.findById key, include: includeParams[0]
      .then (queue) ->
        if not util.isInQueue(user.id, queue.Spots)
          models.Spot.create spot
            .then (spot) ->
              models.Spot.findById spot.key, include: includeParams[0].include
            .then (spot) ->
              res.location "/api/spots/#{spot.key}"
              res.status(201).send null
              io.to(queue.key).emit 'join', spot
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

