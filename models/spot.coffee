module.exports = (sequelize, DataTypes) ->
  Spot = sequelize.define 'Spot',
    key:
      type: DataTypes.INTEGER
      primaryKey: true
      autoIncrement: true
  ,
    underscored: true
    classMethods:
      associate: (models) ->
        # associations can be defined here
        Spot.hasOne models.User,
          as: 'holder'
        Spot.belongsTo models.Queue

  Spot
