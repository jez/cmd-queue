models = require '../models'
util   = require '../public/src/util'

includeParams = [
    model: models.Queue
    include: [
      model: models.User
      as: 'Owners'
    ]
  ]

exports.index = (req, res, next) ->
  models.Spot.findAll include: includeParams
    .then (spots) ->
      res.json spots

exports.show = (req, res, next) ->
  key = req.params.key
  models.Spot.findById key, include: includeParams
    .then (spot) ->
      res.json spot

exports.create = (req, res, next) ->
  spot =
    HolderId: req.user.id

  models.Spot.create spot
    .then (spot) ->
      res.location "/spots/#{spot.key}/"
      res.status(201).json spot
    .error (err) ->
      # TODO better error message
      res.status(500).send null

exports.destroy = (req, res, next) ->
  key    = req.params.key
  userId = req.user.id

  models.Spot.findById key, include: includeParams
    .then (spot) ->
      if (util.isInOwners userId, spot.Queue.Owners) or spot.HolderId == userId
        models.Spot.destroy { where: { key: key }}
    .then (n) ->
      if n? and n > 0
        res.status(204).send null
      else
        res.status(404).send 'No spots matching search query.'
    .error (err) ->
      # TODO better error message
      res.status(500).send null
