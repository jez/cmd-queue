module.exports = (sequelize, DataTypes) ->
  Queue = sequelize.define 'Queue',
    key:
      allowNull: false
      primaryKey: true
      type: DataTypes.STRING

    displayName:
      allowNull: false
      type: DataTypes.STRING
  ,
    underscored: true
    classMethods:
      associate: (models) ->
        Queue.hasOne models.User,
          as: 'owner'
        Queue.hasMany models.Spot,

  Queue
