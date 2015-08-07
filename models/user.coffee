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
  ,
    underscored: true
    classMethods:
      associate: (models) ->
        # queues this person owns
        User.hasMany models.Queue
        # spots this person is in
        User.hasMany models.Spots

  User
