$       = require 'jquery'
React   = require 'react/addons'
util    = require './util.coffee'
helpers = require './helpers.coffee'

{ AddButton, DoneButton } = require './buttons.cjsx'
{List, ListItem} = require './list.cjsx'

Spot = React.createClass
  render: ->
    onClick = =>
      @props.removeSpot @props.spot, @props.idx

    if @props.ownsQueue or util.holdsSpot userId, @props.spot
      doneButton = <DoneButton onClick={onClick} />

    <ListItem title={@props.spot.Holder.displayName} subtitle={@props.spot.createdAt}>
      {doneButton}
    </ListItem>

QueueHeading = React.createClass
  render: ->
    <ListItem {...@props} type="heading">
      <AddButton onClick={@props.join} />
    </ListItem>

Queue = React.createClass
  getInitialState: ->
    key: '15-131'
    displayName: '15-131'
    Spots: []
    Owners: []

  componentDidMount: ->
    @setState userId: helpers.getUserId()
    $.get "/api/queues/#{@props.params.key}", (data) =>
      @setState data

  join: () ->
    $.post "/api/queues/#{@state.key}/join", (spot) =>
      newState = React.addons.update @state,
        Spots:
          $push: [spot]

      @setState newState

  removeSpot: (spot, idx) ->
    $.ajax "/api/spots/#{spot.key}",
      method: 'DELETE'
      success: =>
        newState = React.addons.update @state,
          Spots:
            $splice: [[idx, 1]]   # splice this spot out

        @setState newState

  render: ->
    queueCount = util.queueCountToString @state.Spots.length
    ownsQueue = util.ownsQueue @state.userId, @state
    spots = @state.Spots.map (spot, idx, arr) =>
      <Spot key={spot.key} ownsQueue={ownsQueue} spot={spot} idx={idx}
        removeSpot={@removeSpot} />

    <List>
      <QueueHeading title={@state.displayName} subtitle={queueCount} join={@join} />
      {spots}
    </List>

module.exports = Queue
