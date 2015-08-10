$           = require 'jquery'
React       = require 'react'
util        = require './util.coffee'

{CMQList, CMQListItem} = require './cmqlist.cjsx'

Spot = React.createClass
  render: ->
    <CMQListItem title={@props.Holder.displayName} subtitle={@props.createdAt}>
      <div className="cmq-delete-spot" />
    </CMQListItem>

Queue = React.createClass
  getInitialState: ->
    key: '15-131'
    displayName: '15-131'
    Spots: []

  componentDidMount: ->
    $.get "/api/queues/#{@props.params.key}", (data) =>
      this.setState data

  render: ->
    queueCount = util.queueCountToString @state.Spots.length
    spots = @state.Spots.map (spot, idx, arr) ->
      <Spot {...spot} />

    <CMQList>
      <CMQListItem title={@props.displayName}
          subtitle={queueCount} type="heading" />
      {spots}
    </CMQList>

module.exports = Queue
