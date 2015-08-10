$           = require 'jquery'
React       = require 'react'
util        = require './util.coffee'

{CMQList, CMQListItem} = require './cmqlist.cjsx'

QueueItem = React.createClass
  render: ->
    subtitle = util.queueCountToString @props.Spots.length
    <CMQListItem title={@props.displayName} subtitle={subtitle}>
      <div className="cmq-delete-queue" />
    </CMQListItem>

CreateQueueButton = React.createClass
  render: ->
    <CMQListItem title="Create a new queue" type="heading" />

QueueList = React.createClass
  getInitialState: ->
    queues: [
      key: '15-131'
      displayName: '15-131'
      Spots: []
    ]

  componentDidMount: ->
    $.get '/api/queues', (data) =>
      this.setState queues: data

  render: ->
    queues = @state.queues.map (queue, idx, arr) ->
      <QueueItem {...queue} />

    <CMQList>
      <CreateQueueButton />
      {queues}
    </CMQList>

module.exports = QueueList
