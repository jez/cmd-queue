$     = require 'jquery'
React = require 'react/addons'
Modal = require './modal.cjsx'
util  = require './util.coffee'

{CMQList, CMQListItem} = require './cmqlist.cjsx'

QueueItem = React.createClass
  render: ->
    subtitle = util.queueCountToString @props.queue.Spots.length
    onClick = =>
      @props.removeQueue @props.queue, @props.idx

    <CMQListItem title={@props.queue.displayName} subtitle={subtitle}>
      <div className="cmq-delete-queue" onClick={onClick}>
        &#x2715;
      </div>
    </CMQListItem>

CreateQueueButton = React.createClass
  click: ->
    callback = (cancelled, queue) =>
      React.unmountComponentAtNode $('#modal-target')[0]
      return if cancelled
      @props.addQueue queue

    React.render <Modal callback={callback} />, $('#modal-target')[0]

  render: ->
    <CMQListItem type="heading" title="Create a new queue" onClick={@click} />

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
            $splice: [[idx, idx]]   # splice this queue out

        @setState newState

  componentDidMount: ->
    $.get '/api/queues', (data) =>
      @setState queues: data

  render: ->
    queues = @state.queues.map (queue, idx, arr) =>
      <QueueItem key={queue.key} queue={queue} idx={idx}
        removeQueue={@removeQueue} />

    <CMQList>
      <CreateQueueButton addQueue={@addQueue} />
      {queues}
    </CMQList>

module.exports = QueueList
