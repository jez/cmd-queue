module.exports = (sequelize, DataTypes) ->
  Exception = sequelize.define 'Exception',
    id:
      type: DataTypes.UUID
      primaryKey: true
      defaultValue: DataTypes.UUIDV4

    message: DataTypes.STRING
    route:   DataTypes.STRING
    status:  DataTypes.INTEGER
    trace:   DataTypes.TEXT
    tag:     DataTypes.STRING
  ,
    classMethods:
      associate: (models) ->
        # associations can be defined here
        Exception.belongsTo models.User

  Exception
