models = require '../models'
util   = require '../public/src/util'

includeParams = [
  model: models.Queue
  include: [
    model: models.User
    as: 'Owners'
  ]
]

module.exports = (io) ->
  index: (req, res, next) ->
    models.Spot.findAll include: includeParams
      .then (spots) ->
        res.json spots

  show: (req, res, next) ->
    key = req.params.key
    models.Spot.findById key, include: includeParams
      .then (spot) ->
        res.json spot

  create: (req, res, next) ->
    spot =
      HolderId: req.user.id

    models.Spot.create spot
      .then (spot) ->
        res.location "/spots/#{spot.key}/"
        res.status(201).json spot
      .error (err) ->
        ex = new Error 'Error creating spot'
        ex.status = 500
        ex.type = 'json-error'
        next ex

  destroy: (req, res, next) ->
    key  = req.params.key
    user = req.user
    queue = ''

    models.Spot.findById key, include: includeParams
      .then (spot) ->
        if (util.isInOwners user, spot.Queue.Owners) or (util.holdsSpot user, spot)
          queue = spot.Queue
          models.Spot.destroy { where: { key: key }}
      .then (n) ->
        if n? and n > 0
          res.status(204).send null
          io.to(queue.key).emit 'done', key: key
        else
          res.status(404).send 'No spots matching search query.'
      .error (err) ->
        ex = new Error 'Error destroying spot'
        ex.status = 500
        ex.type = 'json-error'
        next ex
