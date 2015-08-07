passport = require 'passport'

exports.ensureAuthenticated = (req, res, next) ->
  if req.isAuthenticated()
    next()
  else
    res.status(401).send null

exports.login = passport.authenticate 'google',
  scope: ['profile', 'email']
  hd: 'andrew.cmu.edu'

exports.callback = passport.authenticate 'google'

exports.after = (req, res) ->
  res.redirect '/'

exports.logout = (req, res) ->
  req.logout()
  res.redirect '/'
