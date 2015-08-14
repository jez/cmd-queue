# Module dependencies.

models = require '../models'
app    = require('../app')(models.sequelize)
http   = require 'http'
config = require '../config'

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

# Create HTTP server.

app.set 'port', config.port
server = http.createServer app
server.on 'error', onError
server.on 'listening', onListening

# Listen on provided port, on all network interfaces.

models.sequelize.sync().then ->
  server.listen config.port
