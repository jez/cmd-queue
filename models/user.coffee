module.exports = (sequelize, DataTypes) ->
  User = sequelize.define 'User',
    # All of these fields are guaranteed to be populated by CMU's Google Apps
    # accounts. Extending this to arbitrary Google accounts might break these
    # assumptions.
    id:
      allowNull: false
      primaryKey: true
      type: DataTypes.STRING

    displayName:
      allowNull: false
      type: DataTypes.STRING

    givenName:
      allowNull: false
      type: DataTypes.STRING

    familyName:
      allowNull: false
      type: DataTypes.STRING

    email:
      allowNull: false
      type: DataTypes.STRING
      validate:
        isEmail: true

    isAdmin:
      type: DataTypes.BOOLEAN
      defaultValue: false
  ,
    classMethods:
      associate: (models) ->
        User.belongsToMany models.Queue,
          as: 'Queues'
          through: 'QueueOwners'
          foreignKey: 'OwnerId'

        User.hasMany models.Spot,
          as: 'Holders'
          foreignKey: 'HolderId'

  User
