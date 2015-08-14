config = require '../config'
models = require '../models'

if config.mailgunAPIKey
  { Mailgun } = require('mailgun')
  mg = new Mailgun config.mailgunAPIKey


# ----- middleware -----

exports.notFoundHandler = (req, res, next) ->
  err = new Error 'Not Found'
  err.status = 404
  err.type = 'not-found'
  next err

exports.handleErrors = (err, req, res, next) ->
  ex =
    message: err.message
    route:   req.path
    status:  err.status  or 500
    trace:   err.trace
    tag:     err.type    or 'error'
    UserId:  if req.user then req.user.id else null

  models.Exception.create ex
    .then (ex) ->
      # log exception and trace
      console.error "[#{ex.createdAt}] [#{ex.tag}] [#{ex.status}] [#{ex.message}]"
      console.error ex.trace

      # optionally send notification emails through Mailgun
      if mg and (ex.status >= 500)
        subject = "[cq-errors] #{ex.message}"
        body = JSON.stringify ex.trace, null, 2

        mg.sendText config.mailgunFrom,
          config.mailgunTo,
          subject,
          body,
          (err) ->
            if err
              console.error "Error sending exception mail [err: #{err}]"

      # clean up error information in production
      if config.nodeEnv == 'production'
        delete ex.trace

      switch ex.type
        when 'json-error'
          res.status ex.status
          res.json
            success: false
            id:      ex.id
            message: ex.message
        else
          res.status ex.status
          res.render 'error', ex

# ----- RESTful routes -----

# TODO: Fancy admin panel screen
#exports.index = (req, res, next) ->

exports.show = (req, res, next) ->
  id = req.params.id

  models.Exception.findById id
    .then (ex) ->
      res.render 'error', ex

