$     = require 'jquery'
React = require 'react/addons'
Modal = require './modal.cjsx'
util  = require './util.coffee'

{ Link } = require 'react-router'

{ DeleteButton } = require './buttons.cjsx'
{List, ListItem} = require './list.cjsx'

QueueItem = React.createClass
  render: ->
    subtitle = util.queueCountToString @props.queue.Spots.length
    onClick = (e) =>
      e.preventDefault()
      @props.removeQueue @props.queue, @props.idx

    <Link to="queue" params={@props.queue}>
      <ListItem title={@props.queue.displayName} subtitle={subtitle}>
        <DeleteButton onClick={onClick} />
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
      key: '15-131'
      displayName: '15-131'
      Spots: []
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
    $.get '/api/queues', (data) =>
      @setState queues: data

  render: ->
    queues = @state.queues.map (queue, idx, arr) =>
      <QueueItem key={queue.key} queue={queue} idx={idx}
        removeQueue={@removeQueue} />

    <List>
      <CreateQueueButton addQueue={@addQueue} />
      {queues}
    </List>

module.exports = QueueList
