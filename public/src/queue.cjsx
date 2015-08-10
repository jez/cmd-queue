$           = require 'jquery'
React       = require 'react/addons'
util        = require './util.coffee'

{CMQList, CMQListItem} = require './cmqlist.cjsx'

Spot = React.createClass
  render: ->
    onClick = =>
      @props.removeSpot @props.spot, @props.idx
    <CMQListItem title={@props.spot.Holder.displayName} subtitle={@props.spot.createdAt}>
      <div className="cmq-delete-spot" onClick={onClick}>
        <div className="checkmark-circle" />
        <div className="checkmark-stem" />
        <div className="checkmark-kick" />
      </div>
    </CMQListItem>

QueueHeading = React.createClass
  render: ->
    <CMQListItem {...@props} type="heading">
      <div className="cmq-join-queue" onClick={@props.join}>
        <div className="checkmark-circle" />
        <div className="checkmark-plus">&#x2715;</div>
      </div>
    </CMQListItem>

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

    <CMQList>
      <QueueHeading title={@state.displayName} subtitle={queueCount} join={@join} />
      {spots}
    </CMQList>

module.exports = Queue
