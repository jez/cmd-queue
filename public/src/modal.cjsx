React = require 'react'
util  = require './util.coffee'

{Form, TextInput, Button} = require './forms.cjsx'

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
      valid: true

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
      invalidWarning = """
        This field must be made up of alphanumeric characters, hyphens, or
        underscores, and it can't start nor end with punctuation.
        """

    <div className="modal-canvas #{@state.state}" onClick={@blur}>
      <div className="modal" onClick={@nop}>
        <h1>Create a new queue</h1>
        <Form onSubmit={@submit}>
          <TextInput className="add-queue-display-name"
              type="text"
              name="displayName"
              placeholder="My Fancy Queue"
              value={@state.displayName}
              onChange={@changeDisplayName} />
          <TextInput className="add-queue-key"
              type="text"
              name="key"
              placeholder="my-fancy-queue"
              value={@state.key}
              onChange={@changeKey}
              helpText={invalidWarning} />
          <Button>Create</Button>
        </Form>
      </div>
    </div>

module.exports = Modal
