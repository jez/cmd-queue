#!/usr/bin/env coffee

# we don't actually need all these to be set, so let's fake it
process.env.GOOGLE_CLIENT_ID = true
process.env.GOOGLE_CLIENT_SECRET = true
process.env.SESSION_SECRET = 'lol'

models = require '../models'

email = process.argv[2]

unless email
  console.log "Wait, which user did you want to make an admin?"

console.log "Making #{email} an admin..."

models.User.update isAdmin: true,
    where: { email }
  .then (user) ->
    console.log "Success!"
  .error (err) ->
    console.log "Couldn't make the user an admin :("
    console.log err

