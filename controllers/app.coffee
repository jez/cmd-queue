exports.app = (req, res, next) ->
  res.render 'app',
    loggedIn: req.isAuthenticated()
    userId: if req.user then req.user.id else null
