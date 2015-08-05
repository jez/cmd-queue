models = require '../models'

exports.index = (req, res, next) ->
  models.Spot.findAll()
    .then (spots) ->
      res.json spots

exports.show = (req, res, next) ->
  id = req.params.id
  models.Spot.find id
    .then (spot) ->
      res.json spot

exports.create = (req, res, next) ->
  spot =
    email: req.body.email

  models.Spot.create spot
    .then ->
      res.location "/spots/#{spot.id}/"
      res.status(201).send null
    .error (err) ->
      # TODO better error message
      res.status(500).send null

exports.destroy = (req, res, next) ->
  id = req.params.id

  models.Spot.destroy { where: { id: id }}
    .then (affected_rows) ->
      res.status(200).send null
    .error (err) ->
      # TODO better error message
      res.status(500).send null
