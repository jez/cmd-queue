React = require 'react'

Form = React.createClass
  render: ->
    <form className="cq-form" onSubmit={@props.onSubmit}>
      {@props.children}
    </form>

TitleLabel = React.createClass
  render: ->
    <label className="cq-input-title cq-block-label">{@props.title}</label>

TextInput = React.createClass
  render: ->
    <div className="cq-form-element-wrapper">
      <TitleLabel title={@props.title} />
      <input {...@props} className="cq-text-input #{@props.className}" />
      <label className="cq-helptext cq-block-label">{@props.helpText}</label>
    </div>

Checkbox = React.createClass
  render: ->
    <div className="cq-form-element-wrapper">
      <TitleLabel title={@props.title} />
      <input className="cq-checkbox" type="checkbox" {...@props} />
      <label className="cq-helptext">{@props.helpText}</label>
    </div>

Button = React.createClass
  render: ->
    <button className="cq-button" {...@props}>{@props.children}</button>

module.exports = {Form, TitleLabel, TextInput, Checkbox, Button}
