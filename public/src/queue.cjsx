_       = require 'underscore'
$       = require 'jquery'
moment  = require 'moment'
React   = require 'react/addons'
util    = require './util.coffee'

{ AddButton, DoneButton } = require './buttons.cjsx'
{List, ListItem} = require './list.cjsx'

Spot = React.createClass
  render: ->
    onClick = =>
      @props.removeSpot @props.spot

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
    email: ''

  submit: (ev) ->
    ev.preventDefault()
    @props.addOwner @state.email
    @setState email: ''

  onChange: (ev) ->
    @setState
      email: ev.target.value

  render: ->
    <ListItem subtitle="Invite people to administer this queue by Andrew email"
        type="no-padding">
      <form className="cq-listitem-form" onSubmit={@submit}>
        <input className="modal-input" type="email" name="email"
          placeholder="carnegie@andrew.cmu.edu" value={@state.email}
          onChange={@onChange} />
      </form>
    </ListItem>

Queue = React.createClass
  getInitialState: ->
    key: ''
    displayName: 'Loading...'
    Spots: []
    Owners: []

  componentDidMount: ->
    $.get "/api/queues/#{@props.params.key}", (queue) =>
      @setState queue

      window.socket.emit 'enter', queue.key

    window.socket.on 'join', (spot) =>
      newState = React.addons.update @state,
        Spots:
          $push: [spot]

      @setState newState

    window.socket.on 'done', ({key}) =>
      idx = _.find @state.Spots, (spot) -> spot.key == key
      newState = React.addons.update @state,
        Spots:
          $splice: [[idx, 1]]   # splice this spot out

      @setState newState

  join: ->
    $.post "/api/queues/#{@state.key}/join"

  addOwner: (email) ->
    $.ajax "/api/queues/#{@state.key}",
      method: 'PUT'
      data:
        owner: email
      success: (queue) =>
        @setState queue

  removeSpot: (spot) ->
    $.ajax "/api/slots/#{spot.key}",
      method: 'DELETE'

  render: ->
    queueCount = util.queueCountToString @state.Spots.length

    ownsQueue = util.isInOwners window.user, @state.Owners
    holdsSpot = (spot) => util.holdsSpot window.user.id, spot
    spots = @state.Spots.map (spot, idx, arr) =>
      <Spot key={spot.key} spot={spot}
        holdsSpot={holdsSpot} ownsQueue={ownsQueue} removeSpot={@removeSpot} />

    if ownsQueue
      addOwnerButton = <AddOwnerButton addOwner={@addOwner} />

    canJoin = not util.isInQueue window.user.id, @state.Spots
    <List>
      <QueueHeading title={@state.displayName} subtitle={queueCount}
        join={@join if canJoin} />
      {addOwnerButton}
      {spots}
    </List>

module.exports = Queue
