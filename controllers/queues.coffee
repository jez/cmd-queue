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
    res.status(500).send 'Invalid key for queue'

  models.Queue.create queue
    .then (queue) ->
      queue.addOwner user
    .then ->
      models.Queue.findById queue.key, include: includeParams
    .then (queue) ->
      res.location "/queues/#{queue.key}"
      res.status(201).json queue
    .error (err) ->
      # TODO better error message
      res.status(500).send null

exports.destroy = (req, res, next) ->
  key = req.params.key

  models.Queue.destroy { where: { key: key }}
    .then (n) ->
      res.status(204).send null
    .error (err) ->
      # TODO better error message
      res.status(500).send null

exports.modify = (req, res, next) ->
  key    = req.params.key
  owners = req.body.owners

  models.Queue.findById key
    .then (queue) ->
      queue.addOwners owners
    .then ->
      models.Queue.findById queue.key, include: includeParams
    .then (queue) ->
      res.status(204).json queue
    .error (err) ->
      # TODO better error message
      res.status(500).send null

# non-RESTful endpoints

exports.join = (req, res, next) ->
  spot =
    QueueKey: req.params.key
    HolderId: req.user.id

  models.Spot.create spot
    .then (spot) ->
      models.Spot.findById spot.key, include: includeParams[0].include
    .then (spot) ->
      res.location "/api/spots/#{spot.key}"
      res.status(201).json spot
    .error (err) ->
      # TODO better error message
      res.status(500).send null

