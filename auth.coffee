passport       = require 'passport'
GoogleStrategy = require('passport-google-oauth').OAuth2Strategy
models         = require './models'
config         = require './config'

# Passport session setup.
#   To support persistent login sessions, Passport needs to be able to
#   serialize users into and deserialize users out of the session.  Typically,
#   this will be as simple as storing the user ID when serializing, and finding
#   the user by ID when deserializing.  However, since this example does not
#   have a database of user records, the complete Google profile is
#   serialized and deserialized.
passport.serializeUser (user, done) ->
  done null, user.id

passport.deserializeUser (id, done) ->
  models.User.findById id
    .then (user) ->
      done null, user
    .error (err) ->
      done err, null

passport.use new GoogleStrategy
  clientID: config.googleClientId
  clientSecret: config.googleClientSecret
  callbackURL: "#{config.oauthCallbackHost}/auth/google/callback"
, (accessToken, refreshToken, profile, done) ->
  # This is an array, but we need just a single email, so let's at least be
  # smart about which array element we take.
  emails = profile.emails.filter (email, idx, arr) ->
    email.type == 'account' and email.value.indexOf('andrew.cmu.edu') > 0
  .map (email, idx, arr) -> email.value

  user =
    id:          profile.id
    displayName: profile.displayName
    givenName:   profile.name.givenName
    familyName:  profile.name.familyName
    email:       emails[0]

  models.User.findOrCreate where: user
    .spread (user, created) ->
      done null, user
    .error (err) ->
      done err, null

module.exports = (app) ->
  app.use passport.initialize()
  app.use passport.session()
