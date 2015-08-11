$           = require 'jquery'
React       = require 'react/addons'
util        = require './util.coffee'

{ AddButton, DoneButton } = require './buttons.cjsx'
{List, ListItem} = require './list.cjsx'

Spot = React.createClass
  render: ->
    onClick = =>
      @props.removeSpot @props.spot, @props.idx
    <ListItem title={@props.spot.Holder.displayName} subtitle={@props.spot.createdAt}>
      <DoneButton onClick={onClick} />
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

  componentDidMount: ->
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
    spots = @state.Spots.map (spot, idx, arr) =>
      <Spot key={spot.key} spot={spot} idx={idx} removeSpot={@removeSpot} />

    <List>
      <QueueHeading title={@state.displayName} subtitle={queueCount} join={@join} />
      {spots}
    </List>

module.exports = Queue
