exports.index = (req, res, next) ->
  res.render 'index',
    title: 'Express'
    user: JSON.stringify(req.user, null, 2)
