express = require 'express'

# ----- index routes ----------------------------------------------------------
indexRouter = express.Router()
index = require './controllers/index'

indexRouter.get '/', index.index

# ---- auth routes ------------------------------------------------------------
authRouter = express.Router()
auth = require './controllers/auth'

authRouter.get '/login'           , auth.login
authRouter.get '/google/callback' , auth.callback, auth.after
authRouter.get '/logout'          , auth.logout

# ---- queues routes ----------------------------------------------------------
queuesRouter = express.Router()
queues = require './controllers/queues'

queuesRouter.get    '/'      , queues.index
queuesRouter.get    '/:key/' , queues.show
queuesRouter.post   '/'      , queues.create
queuesRouter.delete '/:key/' , queues.destroy

# ---- spots routes -----------------------------------------------------------
spotsRouter = express.Router()
spots = require './controllers/spots'

spotsRouter.get    '/'      , spots.index
spotsRouter.get    '/:key/' , spots.show
spotsRouter.post   '/'      , spots.create
spotsRouter.delete '/:key/' , spots.destroy

# ----- app routes ------------------------------------------------------------

module.exports = (app) ->
  # Register routers
  app.use '/'       , indexRouter
  app.use '/auth'   , authRouter
  app.use '/queues' , queuesRouter
  app.use '/spots'  , spotsRouter