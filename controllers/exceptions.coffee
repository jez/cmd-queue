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
    trace:   err.stack
    tag:     err.type    or 'error'
    UserId:  if req.user then req.user.id else null

  models.Exception.create ex
    .then (ex) ->
      # log exception and trace
      console.error "[#{ex.createdAt}] [#{ex.tag}] [#{ex.status}] [#{ex.message}] [#{ex.id}]"
      console.error ex.trace

      # optionally send notification emails through Mailgun
      if mg and (ex.status >= 500)
        subject = "[cq-errors] #{ex.status}: #{ex.message}"
        link = "http://#{req.headers.host}/admin/exceptions/#{ex.id}"
        body = "Oh noes, there was an error in ⌘ + Queue!

          <a href=\"#{link}\">#{link}</a>

          #{ex.message}
          <pre>
          #{ex.trace}
          </pre>
          "

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

      console.log ex
      switch ex.type
        when 'json-error'
          res.status ex.status
          res.json
            success: false
            id:      ex.id
            message: ex.message
        else
          console.log ex.status
          res.status ex.status
          res.render 'error', ex: ex

# ----- RESTful routes -----

# TODO: Fancy admin panel screen
#exports.index = (req, res, next) ->

exports.show = (req, res, next) ->
  id = req.params.id

  models.Exception.findById id
    .then (ex) ->
      res.render 'error', ex

