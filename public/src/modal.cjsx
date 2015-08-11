React = require 'react'
util  = require './util.coffee'

Modal = React.createClass
  getInitialState: ->
    displayName: ''
    key: ''
    state: 'active'
    valid: true

  blur: ->
    @setState state: ''
    cancelled = true
    @props.callback cancelled

  nop: (ev) ->
    # Prevent click from bubbling up to blur
    ev.stopPropagation()

  changeDisplayName: (ev) ->
    @setState
      displayName: ev.target.value
      key: util.slugify ev.target.value

  changeKey: (ev) ->
    @setState valid: util.validateSlug ev.target.value

    @setState key: ev.target.value

  submit: (ev) ->
    ev.preventDefault()
    return unless @state.valid

    @setState state: ''
    cancelled = not (@state.displayName and @state.key)
    @props.callback cancelled,
      displayName: @state.displayName
      key:         @state.key

  render: ->
    unless @state.valid
      invalidWarning =
        <label className="modal-warning">
          This field must be made up of alphanumeric characters, hyphens, or
          underscores, and it can't start nor end with punctuation.
        </label>

    <div className="modal-canvas #{@state.state}" onClick={@blur}>
      <div className="modal" onClick={@nop}>
        <h1>Create a new queue</h1>
        <form className="modal-form" onSubmit={@submit}>
          <input className="modal-input" type="text" name="displayName"
              placeholder="My Fancy Queue" value={@state.displayName}
              onChange={@changeDisplayName} />
          <input className="modal-input" type="text" name="key"
              placeholder="my-fancy-queue" value={@state.key}
              onChange={@changeKey} />
          {invalidWarning}
          <button className="modal-button">Create</button>
        </form>
      </div>
    </div>

module.exports = Modal
