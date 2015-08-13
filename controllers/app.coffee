exports.forceHTTPS = (req, res, next) ->
  # redirect to HTTPS in production, take care of Heroku's special https
  # handling
  if not (req.secure or (req.header('x-forwarded-proto') == 'https')) and
      process.env.NODE_ENV == 'production'
    res.redirect "https://#{req.headers.host}#{req.url}"
  else
    next()

exports.app = (req, res, next) ->
  res.render 'app',
    loggedIn: req.isAuthenticated()
    userId: if req.user then req.user.id else null
