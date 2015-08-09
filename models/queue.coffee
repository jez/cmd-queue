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
    classMethods:
      associate: (models) ->
        Queue.belongsToMany models.User,
          as: 'Owners'
          through: 'QueueOwners'

        Queue.hasMany models.Spot

  Queue
