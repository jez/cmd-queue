React = require 'react'

AddButton = React.createClass
  render: ->
    <div className="cq-add-button" onClick={@props.onClick}>
      <div className="cq-circle-icon" />
      <div className="cq-plus-icon">&#x2715;</div>
    </div>

DeleteButton = React.createClass
  render: ->
    <div className="cq-delete-button" onClick={@props.onClick}>
      <div className="cq-circle-icon" />
      <div className="cq-x-icon">&#x2715;</div>
    </div>

DoneButton = React.createClass
  render: ->
    <div className="cq-done-button" onClick={@props.onClick}>
      <div className="cq-circle-icon" />
      <div className="cq-checkmark-stem-icon" />
      <div className="cq-checkmark-kick-icon" />
    </div>

module.exports = { AddButton, DeleteButton, DoneButton }
