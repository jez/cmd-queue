express        = require 'express'
path           = require 'path'
favicon        = require 'serve-favicon'
logger         = require 'morgan'
cookieParser   = require 'cookie-parser'
bodyParser     = require 'body-parser'
session        = require 'express-session'
SequelizeStore = require('connect-session-sequelize')(session.Store)

module.exports = (sequelize) ->
  app = express()

  # view engine setup
  app.set 'views', path.join(__dirname, 'views')
  app.set 'view engine', 'jade'

  # uncomment after placing your favicon in /public
  #app.use(favicon(__dirname + '/public/favicon.ico'))
  app.use logger('dev')
  app.use bodyParser.json()
  app.use bodyParser.urlencoded({ extended: false })
  app.use cookieParser()
  app.use express.static(path.join(__dirname, 'public'))

  # sessions
  app.use session
    secret: 'TODO: Handle secrets'
    store: new SequelizeStore db: sequelize

  # Initialize authentication
  require('./auth')(app)

  # Initialize routes
  require('./routes')(app)

  # catch 404 and forward to error handler
  app.use (req, res, next) ->
    err = new Error 'Not Found'
    err.status = 404
    next err

  # error handlers

  # development error handler
  # will print stacktrace
  if app.get('env')  == 'development'
    app.use (err, req, res, next) ->
      res.status(err.status || 500)
      res.render 'error',
        message: err.message
        error: err

  # production error handler
  # no stacktraces leaked to user
  app.use (err, req, res, next) ->
    res.status(err.status || 500)
    res.render 'error',
      message: err.message
      error: {}

  app
