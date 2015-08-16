$       = require 'jquery'
moment  = require 'moment'
React   = require 'react/addons'
util    = require './util.coffee'
helpers = require './helpers.coffee'

{ AddButton, DoneButton } = require './buttons.cjsx'
{List, ListItem} = require './list.cjsx'

Spot = React.createClass
  render: ->
    onClick = =>
      @props.removeSpot @props.spot, @props.idx

    if @props.ownsQueue or @props.holdsSpot @props.spot
      doneButton = <DoneButton onClick={onClick} />

    waitTime = "has been waiting for #{moment(@props.spot.createdAt).fromNow(true)}"

    <ListItem title={@props.spot.Holder.displayName} subtitle={waitTime}>
      {doneButton}
    </ListItem>

QueueHeading = React.createClass
  render: ->
    if @props.join
      addButton = <AddButton onClick={@props.join} />
    <ListItem {...@props} type="heading">
      {addButton}
    </ListItem>

Queue = React.createClass
  getInitialState: ->
    key: ''
    displayName: 'Loading...'
    Spots: []
    Owners: []

  componentDidMount: ->
    @setState user: helpers.getUserFromDom()
    $.get "/api/queues/#{@props.params.key}", (data) =>
      @setState data

  join: () ->
    $.post "/api/queues/#{@state.key}/join", (spot) =>
      newState = React.addons.update @state,
        Spots:
          $push: [spot]

      @setState newState

  removeSpot: (spot, idx) ->
    $.ajax "/api/slots/#{spot.key}",
      method: 'DELETE'
      success: =>
        newState = React.addons.update @state,
          Spots:
            $splice: [[idx, 1]]   # splice this spot out

        @setState newState

  render: ->
    queueCount = util.queueCountToString @state.Spots.length

    ownsQueue = util.isInOwners @state.user, @state.Owners
    holdsSpot = (spot) => util.holdsSpot @state.user.id, spot
    spots = @state.Spots.map (spot, idx, arr) =>
      <Spot key={spot.key} spot={spot} idx={idx}
        holdsSpot={holdsSpot} ownsQueue={ownsQueue} removeSpot={@removeSpot} />

    canJoin = not util.isInQueue(@state.user.id, @state.Spots)
    <List>
      <QueueHeading title={@state.displayName} subtitle={queueCount}
        join={@join if canJoin} />
      {spots}
    </List>

module.exports = Queue
