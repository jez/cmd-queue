React = require 'react'

CMQList = React.createClass
  render: ->
    <div className="cmq-list">
      {@props.children}
    </div>

CMQListItem = React.createClass
  render: ->
    classes = switch @props.type
      when 'heading' then 'cmq-listheading'

    # TODO: add links
    <div className="cmq-listitem #{classes}">
      {@props.children}
      <div className="cmq-listitem-title">{@props.title}</div>
      <div className="cmq-listitem-subtitle">{@props.subtitle}</div>
    </div>


module.exports = {CMQList, CMQListItem}
