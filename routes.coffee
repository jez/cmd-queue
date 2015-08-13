express = require 'express'

auth   = require './controllers/auth'
queues = require './controllers/queues'
spots  = require './controllers/spots'
app    = require './controllers/app'

router = express.Router()

router.get    '/auth/login'           , auth.storeNext, auth.login
router.get    '/auth/google/callback' , auth.callback, auth.after
router.get    '/auth/logout'          , auth.ensureAuthenticated, auth.logout

router.get    '/api/queues'           , queues.index
router.get    '/api/queues/:key'      , queues.show
router.post   '/api/queues'           , queues.create
router.put    '/api/queues/:key'      , queues.modify
router.delete '/api/queues/:key'      , queues.destroy
router.post   '/api/queues/:key/join' , queues.join

router.get    '/api/spots'            , spots.index
router.get    '/api/spots/:key'       , spots.show
router.post   '/api/spots'            , spots.create
router.delete '/api/spots/:key'       , spots.destroy

router.get    '/'                     , app.app
router.get    '/:key'                 , auth.logInFirst, app.app

module.exports = (app) ->
  # Register routers
  app.use app.forceHTTPS
  app.use '/api', auth.ensureAuthenticated
  app.use '/', router
