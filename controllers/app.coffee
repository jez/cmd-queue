exports.forceHTTPS = (req, res, next) ->
  # redirect to HTTPS in production
  console.log req.secure
  console.log process.env.NODE_ENV
  if !req.secure && process.env.NODE_ENV == 'production'
    res.redirect "https://#{req.headers.host}#{req.url}"
  else
    next()

exports.app = (req, res, next) ->
  res.render 'app',
    loggedIn: req.isAuthenticated()
    userId: if req.user then req.user.id else null
