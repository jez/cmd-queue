# For some odd reason, this isn't working. There's no reason why it shouldn't. I
# think either Heroku is messing up my config, or I need to flip a setting in
# Heroku somewhere.
#
# Instead, I'm requiring HTTPS through CloudFlare page rules, a hacky but
# effective solution
#config = require '../config'
#
#exports.forceHTTPS = (req, res, next) ->
#  # redirect to HTTPS in production, take care of Heroku's special https
#  # handling
#  if not (req.secure or (req.header('x-forwarded-proto') == 'https')) and
#      config.nodeEnv == 'production'
#    res.redirect "https://#{req.headers.host}#{req.url}"
#  else
#    next()

models = require '../models'

exports.app = (req, res, next) ->
  key = req.params.key
  user = req.user
  if key
    models.Queue.findById key
      .then (queue) ->
        if queue
          res.render 'app',
            loggedIn: req.isAuthenticated()
            user: user
        else
          ex = new Error 'Queue not found'
          ex.status = 404
          next ex
      .error ->
        ex = new Error 'Error finding queue'
        ex.status = 500
        next ex
  else
    res.render 'app',
      loggedIn: req.isAuthenticated()
      user: user
