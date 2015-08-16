module.exports = (sequelize, DataTypes) ->
  Queue = sequelize.define 'Queue',
    key:
      allowNull: false
      primaryKey: true
      validate:
        notEmpty: true
      type: DataTypes.STRING

    displayName:
      allowNull: false
      validate:
        notEmpty: true
      type: DataTypes.STRING
  ,
    classMethods:
      associate: (models) ->
        Queue.belongsToMany models.User,
          as: 'Owners'
          through: 'QueueOwners'

        Queue.hasMany models.Spot

  Queue
