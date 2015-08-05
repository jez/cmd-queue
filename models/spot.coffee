module.exports = (sequelize, DataTypes) ->
  Spot = sequelize.define 'Spot',
    email:
      allowNull: false,
      type: DataTypes.STRING,
      validate:
        isEmail: true,
  ,
    classMethods:
      associate: (models) ->
        # associations can be defined here
        Spot.belongsTo models.Queue

  Spot;
