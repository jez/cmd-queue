$     = require 'jquery'
React = require 'react'

QueueItem = React.createClass
  render: ->
    subtitle = switch @props.length
      when 0 then 'No people in the queue'
      when 1 then '1 person in the queue'
      else "#{@props.length} people in the queue"

    <div className="cmq-queue-item">
      <div className="cmq-queue-item-title">{@props.displayName}</div>
      <div className="cmq-queue-item-subtitle">{subtitle}</div>
    </div>

CreateQueueButton = React.createClass
  render: ->
    <div className="cmq-queue-item">
      <div className="cmq-queue-item-title">Create a new queue</div>
    </div>

QueueList = React.createClass
  getInitialState: ->
    queues: [
      key: '15-131'
      displayName: '15-131'
      owners: [
          id: '321'
          displayName: 'Jake Zimmerman'
          givenName: 'Jake'
          familyName: 'Zimmerman'
          email: 'jezimmer@andrew.cmu.edu'
        ,
      ]
      length: 1
    ]

  # componentDidMount: ->
  #   $.get '/api/queues', (data) =>
  #     this.setState data

  render: ->
    queueListItems = @state.queues.map (queue, idx, arr) ->
      <QueueItem {...queue} />

    <div className="cmq-queue-list">
      <CreateQueueButton />
      {queueListItems}
    </div>

module.exports = QueueList
