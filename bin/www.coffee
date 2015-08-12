# Module dependencies.

models = require '../models'
app = require('../app')(models.sequelize)
http = require 'http'

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

# Event listener for HTTP server "error" event.

onError = (error) ->
  if  error.syscall != 'listen'
    throw error

  bind = if typeof port == 'string' then 'Pipe ' + port else 'Port ' + port

  # handle specific listen errors with friendly messages
  switch error.code
    when 'EACCES'
      console.error "#{bind} requires elevated privileges"
      process.exit 1
      break
    when 'EADDRINUSE'
      console.error "#{bind} is already in use"
      process.exit 1
      break
    else
      throw error

# Event listener for HTTP server "listening" event.

onListening = ->
  addr = server.address()
  bind = if typeof addr == 'string' then 'pipe ' + addr else 'port ' + addr.port
  console.log "Listening on #{bind}"

# Get port from environment and store in Express.

port = normalizePort(process.env.PORT || '3000')
app.set 'port', port

# Validate that relevant config has been set

fail = (message, status) ->
  console.error "[error] #{message}. Read the README for more information."
  process.exit(status || 1)

fail 'Google client id not set'     unless process.env.GOOGLE_CLIENT_ID
fail 'Google client secret not set' unless process.env.GOOGLE_CLIENT_SECRET

{GOOGLE_CLIENT_ID, GOOGLE_CLIENT_SECRET, NODE_ENV, DATABASE_URL} = process.env

console.log {GOOGLE_CLIENT_ID, GOOGLE_CLIENT_SECRET, NODE_ENV, DATABASE_URL}

# Create HTTP server.

server = http.createServer app
server.on 'error', onError
server.on 'listening', onListening

# Listen on provided port, on all network interfaces.

models.sequelize.sync().then ->
  server.listen port
