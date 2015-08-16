$       = require 'jquery'
moment  = require 'moment'
React   = require 'react/addons'
util    = require './util.coffee'

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

AddOwnerButton = React.createClass
  getInitialState: ->
    owner: ''

  submit: (ev) ->
    ev.preventDefault()
    #TODO: add ajax call to modify owners
    undefined

  onChange: (ev) ->
    @setState
      owner: ev.target.value

  render: ->
    <ListItem>
      <form className="cq-listitem-form" onSubmit={@submit}>
        <input type="email" name="owner" placeholder="carnegie@andrew.cmu.edu"
            value={@state.owner} onChange={@onChange} />
        <button>Add as owner</button>
      </form>
    </ListItem>

Queue = React.createClass
  getInitialState: ->
    key: ''
    displayName: 'Loading...'
    Spots: []
    Owners: []

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
    $.ajax "/api/slots/#{spot.key}",
      method: 'DELETE'
      success: =>
        newState = React.addons.update @state,
          Spots:
            $splice: [[idx, 1]]   # splice this spot out

        @setState newState

  render: ->
    queueCount = util.queueCountToString @state.Spots.length

    ownsQueue = util.isInOwners window.user, @state.Owners
    holdsSpot = (spot) => util.holdsSpot window.user.id, spot
    spots = @state.Spots.map (spot, idx, arr) =>
      <Spot key={spot.key} spot={spot} idx={idx}
        holdsSpot={holdsSpot} ownsQueue={ownsQueue} removeSpot={@removeSpot} />

    if ownsQueue
      addOwnerButton = <AddOwnerButton />

    canJoin = not util.isInQueue window.user.id, @state.Spots
    <List>
      <QueueHeading title={@state.displayName} subtitle={queueCount}
        join={@join if canJoin} />
      {addOwnerButton}
      {spots}
    </List>

module.exports = Queue
