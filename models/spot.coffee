module.exports = (sequelize, DataTypes) ->
  Spot = sequelize.define 'Spot',
    key:
      type: DataTypes.INTEGER
      primaryKey: true
      autoIncrement: true
  ,
    classMethods:
      associate: (models) ->
        # associations can be defined here
        Spot.belongsTo models.User,
          as: 'Holder'

        Spot.belongsTo models.Queue

  Spot
