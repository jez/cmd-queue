module.exports = (sequelize, DataTypes) ->
  Queue = sequelize.define 'Queue',
    key:
      allowNull: false,
      primaryKey: true,
      type: DataTypes.STRING

    owner:
      allowNull: false,
      type: DataTypes.STRING,
      validate:
        isEmail: true,

    name:
      allowNull: false,
      type: DataTypes.STRING
  ,
    classMethods:
      associate: (models) ->
        # associations can be defined here
        Queue.hasMany models.Spot

  Queue
