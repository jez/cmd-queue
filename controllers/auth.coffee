passport = require 'passport'

exports.logInFirst = (req, res, next) ->
  if req.isAuthenticated()
    next()
  else
    res.redirect "/auth/login?next=#{req.path}"

exports.storeNext = (req, res, next) ->
  if req.query.next
    req.session.next = req.query.next

  next()

exports.login =
  passport.authenticate 'google',
    scope: ['profile', 'email']
    hd: 'andrew.cmu.edu'

exports.callback = passport.authenticate 'google'

exports.after = (req, res) ->
  if req.session.next
    next = req.session.next
    delete req.session
    res.redirect next
  else
    res.redirect '/'

exports.ensureAuthenticated = (req, res, next) ->
  if req.isAuthenticated()
    next()
  else
    res.status(401).send null

exports.ensureAdmin = (req, res, next) ->
  if req.user.isAdmin
    next()
  else
    err = new Error 'Forbidden: Admin'
    err.status = 403
    err.type = 'forbidden'
    next err

exports.logout = (req, res) ->
  req.logout()
  res.redirect '/'
