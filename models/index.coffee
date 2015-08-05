fs        = require 'fs'
path      = require 'path'
Sequelize = require 'sequelize'
basename  = path.basename module.filename
env       = process.env.NODE_ENV || 'development'
config    = require("#{__dirname}/../config/config.json")[env]
sequelize = new Sequelize config.database, config.username, config.password, config
db        = {}

fs
  .readdirSync __dirname
  .filter (file) ->
    return (file.indexOf('.') != 0) && (file != basename)
  .forEach (file) ->
    return unless file[-3..] == '.js' || file[-7..] == '.coffee'
    model = sequelize['import'](path.join __dirname, file)
    db[model.name] = model

Object.keys(db).forEach (modelName) ->
  if 'associate' in db[modelName]
    db[modelName].associate db

db.sequelize = sequelize
db.Sequelize = Sequelize

module.exports = db
