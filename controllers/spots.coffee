models = require '../models'

exports.index = (req, res, next) ->
  models.Spot.findAll()
    .then (spots) ->
      res.json spots

exports.show = (req, res, next) ->
  key = req.params.key
  models.Spot.find key
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
  key = req.params.key

  models.Spot.destroy { where: { key: key }}
    .then (affectedRows) ->
      res.status(204).send null
    .error (err) ->
      # TODO better error message
      res.status(500).send null
