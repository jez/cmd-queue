_       = require 'underscore'
$       = require 'jquery'
moment  = require 'moment'
React   = require 'react/addons'
util    = require './util.coffee'

{ AddButton, DoneButton } = require './buttons.cjsx'
{List, ListItem} = require './list.cjsx'
{Form, TextInput, Checkbox} = require './forms.cjsx'

Spot = React.createClass
  getInitialState: ->
    now: new Date()

  tick: ->
    # Store current time so render can be a pure function of state and props
    @setState now: new Date()

  componentDidMount: ->
    @interval = setInterval @tick, 1000

  componentWillUnmount: ->
    clearInterval @interval

  render: ->
    onClick = =>
      @props.removeSpot @props.spot

    if @props.ownsQueue or util.holdsSpot window.user, @props.spot
      doneButton = <DoneButton onClick={onClick} />

    created = @props.spot.createdAt
    waitTime = "has been waiting for #{moment(created).from @state.now, true}"

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

ModifyQueueButton = React.createClass
  getInitialState: ->
    email: ''
    isPrivate: @props.isPrivate

  componentWillReceiveProps: (nextProps) ->
    @setState
      isPrivate: nextProps.isPrivate

  submitAddOwner: (ev) ->
    ev.preventDefault()
    @props.modifyQueue owner: @state.email
    @setState email: ''

  onChangeEmail: (ev) ->
    @setState
      email: ev.target.value

  onChangeIsPrivate: (ev) ->
    @setState
      isPrivate: ev.target.checked
    @props.modifyQueue isPrivate: ev.target.checked

  render: ->
    isPrivateStr = if @state.isPrivate then '' else 'not'
    <ListItem type="no-padding">
      <Form onSubmit={@submitAddOwner}>
        <TextInput className="modify-queue-owner"
            type="email"
            name="email"
            value={@state.email}
            placeholder="carnegie@andrew.cmu.edu"
            onChange={@onChangeEmail}
            title="Add owners"
            helpText="Invite people to administer this queue by Andrew email" />
        <Checkbox className="modify-queue-is-private"
            name="isPrivate"
            value="isPrivate"
            checked={@state.isPrivate}
            onChange={@onChangeIsPrivate}
            title="Privacy"
            helpText="This queue is #{isPrivateStr} private" />
      </Form>
    </ListItem>

Queue = React.createClass
  getInitialState: ->
    key: ''
    displayName: 'Loading...'
    isPrivate: false
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
      idx = _.findIndex @state.Spots, (spot) -> spot.key == key
      newState = React.addons.update @state,
        Spots:
          $splice: [[idx, 1]]   # splice this spot out

      @setState newState

  join: ->
    $.post "/api/queues/#{@state.key}/join"

  modifyQueue: (data) ->
    $.ajax "/api/queues/#{@state.key}",
      method: 'PUT'
      data: data
      success: (queue) =>
        @setState queue

  removeSpot: (spot) ->
    $.ajax "/api/slots/#{spot.key}",
      method: 'DELETE'

  render: ->
    queueCount = util.queueCountToString @state.Spots.length

    ownsQueue = util.isInOwners window.user, @state.Owners
    spots = @state.Spots.map (spot, idx, arr) =>
      <Spot key={spot.key} spot={spot} ownsQueue={ownsQueue}
          removeSpot={@removeSpot} />

    if ownsQueue
      modifyQueueButton = <ModifyQueueButton isPrivate={@state.isPrivate}
          modifyQueue={@modifyQueue} />

    canJoin = not util.isInQueue window.user.id, @state.Spots
    <List>
      <QueueHeading title={@state.displayName} subtitle={queueCount}
        join={@join if canJoin} />
      {modifyQueueButton}
      {spots}
    </List>

module.exports = Queue
