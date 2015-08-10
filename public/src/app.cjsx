$         = require 'jquery'
React     = require 'react'
Router    = require 'react-router'
QueueList = require './queuelist.cjsx'
Queue     = require './queue.cjsx'

{DefaultRoute, Link, Route, RouteHandler} = Router

CMQueue = React.createClass
  render: ->
    <div className="cmq-wrapper">
      <RouteHandler />
    </div>

routes =
  <Route name="queues" path="/" handler={CMQueue}>
    <Route name="queue" path=":key" handler={Queue} />
    <DefaultRoute handler={QueueList} />
  </Route>

$(document).ready ->
  Router.run routes, Router.HistoryLocation, (Handler) ->
    React.render <Handler />, $('#cmq-target')[0]
