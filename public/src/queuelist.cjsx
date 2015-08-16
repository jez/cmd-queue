$       = require 'jquery'
React   = require 'react/addons'
Modal   = require './modal.cjsx'
util    = require './util.coffee'
helpers = require './helpers.coffee'

{ Link } = require 'react-router'

{ DeleteButton } = require './buttons.cjsx'
{List, ListItem} = require './list.cjsx'

QueueItem = React.createClass
  render: ->
    subtitle = util.queueCountToString @props.queue.Spots.length
    onClick = (ev) =>
      ev.preventDefault()
      @props.removeQueue @props.queue, @props.idx

    if util.isInOwners @props.user, @props.queue.Owners
      deleteButton = <DeleteButton onClick={onClick} />

    <Link to="queue" params={@props.queue}>
      <ListItem title={@props.queue.displayName} subtitle={subtitle}>
        {deleteButton}
      </ListItem>
    </Link>

CreateQueueButton = React.createClass
  click: ->
    callback = (cancelled, queue) =>
      React.unmountComponentAtNode $('#modal-target')[0]
      return if cancelled
      @props.addQueue queue

    React.render <Modal callback={callback} />, $('#modal-target')[0]

  render: ->
    <ListItem type="heading" title="Create a new queue" onClick={@click} />

QueueList = React.createClass
  getInitialState: ->
    queues: [
      key: ''
      displayName: 'Loading...'
      Spots: []
      Owners: []
    ]

  addQueue: (queue) ->
    $.post '/api/queues', queue, (queue) =>
      # since we just created this, Spots is probably empty
      queue.Spots = []
      newState = React.addons.update @state,
        queues:
          $unshift: [queue]

      @setState newState

  removeQueue: (queue, idx) ->
    $.ajax "/api/queues/#{queue.key}",
      method: 'DELETE'
      success: =>
        newState = React.addons.update @state,
          queues:
            $splice: [[idx, 1]]   # splice this queue out

        @setState newState

  componentDidMount: ->
    @setState user: helpers.getUserFromDom()
    $.get '/api/queues', (data) =>
      @setState queues: data.sort (queue1, queue2) ->
        queue1.displayName < queue2.displayName

  render: ->
    queues = @state.queues.map (queue, idx, arr) =>
      <QueueItem user={@state.user} key={queue.key} queue={queue} idx={idx}
        removeQueue={@removeQueue} />

    <List>
      <CreateQueueButton addQueue={@addQueue} />
      {queues}
    </List>

module.exports = QueueList
