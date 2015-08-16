$         = require 'jquery'
helpers   = require './helpers.coffee'
React     = require 'react'
Router    = require 'react-router'
QueueList = require './queuelist.cjsx'
Queue     = require './queue.cjsx'


{DefaultRoute, Link, Route, RouteHandler} = Router

CmdQueue = React.createClass
  render: ->
    <div className="cq-wrapper">
      <RouteHandler />
    </div>

routes =
  <Route name="queues" path="/" handler={CmdQueue}>
    <Route name="queue" path=":key" handler={Queue} />
    <DefaultRoute handler={QueueList} />
  </Route>

$(document).ready ->
  $(document).ajaxError (ev, jqXHR, settings, error) =>
    if jqXHR.status == 401
      window.location.href = '/auth/login'

  if helpers.getUserFromDom()
    Router.run routes, Router.HistoryLocation, (Handler) ->
      React.render <Handler />, $('#cq-target')[0]
