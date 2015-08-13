# For some odd reason, this isn't working. There's no reason why it shouldn't. I
# think either Heroku is messing up my config, or I need to flip a setting in
# Heroku somewhere.
#
# Instead, I'm requiring HTTPS through CloudFlare page rules, a hacky but
# effective solution
#exports.forceHTTPS = (req, res, next) ->
#  # redirect to HTTPS in production, take care of Heroku's special https
#  # handling
#  if not (req.secure or (req.header('x-forwarded-proto') == 'https')) and
#      process.env.NODE_ENV == 'production'
#    res.redirect "https://#{req.headers.host}#{req.url}"
#  else
#    next()

exports.app = (req, res, next) ->
  res.render 'app',
    loggedIn: req.isAuthenticated()
    userId: if req.user then req.user.id else null
