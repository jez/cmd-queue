React = require 'react'

List = React.createClass
  render: ->
    <div className="cq-list">
      {@props.children}
    </div>

ListItem = React.createClass
  render: ->
    classes = switch @props.type
      when 'heading' then 'cq-listheading'
      else ''

    if @props.onClick
      classes += ' button'

    # TODO: add links
    <div className="cq-listitem #{classes}" onClick={@props.onClick}>
      {@props.children}
      <div className="cq-listitem-title">{@props.title}</div>
      <div className="cq-listitem-subtitle">{@props.subtitle}</div>
    </div>


module.exports = {List, ListItem}
