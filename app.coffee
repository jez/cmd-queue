config         = require './config'
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
  app.use(favicon(__dirname + '/public/img/favicon.ico'))
  app.use logger('dev')
  app.use bodyParser.json()
  app.use bodyParser.urlencoded({ extended: false })
  app.use cookieParser()
  app.use express.static(path.join(__dirname, 'public'))

  # sessions
  app.use session
    secret: config.sessionSecret
    store: new SequelizeStore db: sequelize

  app
