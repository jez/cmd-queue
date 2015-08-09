models = require '../models'

exports.index = (req, res, next) ->
  # -- no params --

  # this is kind of an unfortunate query, but I'm not good enought at SQL nor
  # sequelize to be able to join all the queues and their lengths
  models.Queue.findAll
      include: [models.Spot]
    .then (queues) ->
      res.json queues

exports.show = (req, res, next) ->
  key = req.params.key

  models.Queue.findById key,
      include: [models.Spot]
    .then (queue) ->
      res.json queue

exports.create = (req, res, next) ->
  queue =
    key:         req.body.key
    displayName: req.body.displayName
  user = req.user

  models.Queue.create queue
    .then (queue) ->
      queue.addOwner user

    .then ->
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
