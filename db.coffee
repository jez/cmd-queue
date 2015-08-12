# database config
module.exports =
  development:
    dialect: 'sqlite'
    storage: './data/development.sqlite'
  production:
    uri: process.env.DATABASE_URL
