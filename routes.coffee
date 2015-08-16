module.exports = (app) ->
  # --- imports ---
  express    = require 'express'
  router     = express.Router()

  auth       = require './controllers/auth'
  queues     = require './controllers/queues'
  spots      = require './controllers/spots'
  exceptions = require './controllers/exceptions'
  main       = require './controllers/app'

  # --- routes ---
  router.get    '/auth/login'           , auth.storeNext, auth.login
  router.get    '/auth/google/callback' , auth.callback, auth.after
  router.get    '/auth/logout'          , auth.ensureAuthenticated, auth.logout

  router.get    '/api/queues'           , queues.index
  router.get    '/api/queues/:key'      , queues.show
  router.post   '/api/queues'           , queues.create
  router.put    '/api/queues/:key'      , queues.modify
  router.delete '/api/queues/:key'      , queues.destroy
  router.post   '/api/queues/:key/join' , queues.join

  # Why is this called /api/slots not /api/spots? Well, funny you ask!
  # It turns out my adblocker (uBlock Origin) blocks /api/spots! Why?
  # WHO FLIPPIN KNOWS >:O
  router.get    '/api/slots'            , spots.index
  router.get    '/api/slots/:key'       , spots.show
  router.post   '/api/slots'            , spots.create
  router.delete '/api/slots/:key'       , spots.destroy

  router.get    '/admin/exceptions'     , exceptions.index
  router.get    '/admin/exceptions/:id' , exceptions.show

  router.get    '/'                     , main.app
  router.get    '/:key'                 , auth.logInFirst, main.app

  # --- register routers ---
  # HTTPS redirects temporarily disabled. See controllers/app.coffee
  #app.use main.forceHTTPS
  app.use '/api'   , auth.ensureAuthenticated
  app.use '/admin' , auth.ensureAuthenticated, auth.ensureAdmin
  app.use '/'      , router

  # error handling
  app.use exceptions.notFoundHandler, exceptions.handleErrors
