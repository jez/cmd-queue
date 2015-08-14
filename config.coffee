config = null

# Normalize a port into a number, string, or false.
normalizePort = (val) ->
  port = parseInt val, 10

  if isNaN port
    # named pipe
    return val

  if port >= 0
    # port number
    return port

  false

# Validate that relevant config has been set
fail = (message, status) ->
  console.error "[error] #{message}. Read the README for more information."
  process.exit(status || 1)

fallback = (setting, defaultVal) ->
  unless config[setting]
    config[setting] = defaultVal

# initialize config
config =
  nodeEnv:            normalizePort process.env.NODE_ENV
  port:               process.env.PORT
  googleClientId:     process.env.GOOGLE_CLIENT_ID
  googleClientSecret: process.env.GOOGLE_CLIENT_SECRET
  oauthCallbackHost:  process.env.OAUTH_CALLBACK_HOST
  mailgunAPIKey:      process.env.MAILGUN_API_KEY
  mailgunFrom:        process.env.MAILGUN_FROM
  mailgunTo:          process.env.MAILGUN_TO

# validate config
fallback 'nodeEnv', 'development'
fallback 'port', normalizePort '3000'

config.db = require("./db")[config.nodeEnv]

fail 'Google client id not set'     unless config.googleClientId
fail 'Google client secret not set' unless config.googleClientSecret

if config.mailgunAPIKey
  fail 'Need to set mailgun from address'  unless config.mailgunFrom
  fail 'Need to set mailgun to address'    unless config.mailgunTo

fallback 'oauthCallbackHost', "http://localhost:#{config.port}"

module.exports = config
