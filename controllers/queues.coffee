models = require '../models'

exports.index = (req, res, next) ->
  models.Queue.findAll()
    .then (queues) ->
      res.json queues

exports.show = (req, res, next) ->
  key = req.params.key
  models.Queue.find key
    .then (queue) ->
      res.json queue

exports.create = (req, res, next) ->
  queue =
    key:   req.body.key
    owner: req.body.owner
    name:  req.body.name

  models.Queue.create queue
    .then ->
      res.location "/queues/#{queue.key}/"
      res.status(201).send null

    .error (err) ->
      # TODO better error message
      res.status(500).send null

exports.destroy = (req, res, next) ->
  key = req.params.key

  models.Queue.destroy { where: { key: key }}
    .then (affected_rows) ->
      res.status(200).send null
    .error (err) ->
      # TODO better error message
      res.status(500).send null
