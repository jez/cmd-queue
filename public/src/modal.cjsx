React = require 'react'
util  = require './util.coffee'

{Form, TextInput, Checkbox, Button} = require './forms.cjsx'

Modal = React.createClass
  getInitialState: ->
    displayName: ''
    key: ''
    isPrivate: false
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
    @setState
      valid: util.validateSlug ev.target.value
      key: ev.target.value

  changeIsPrivate: (ev) ->
    @setState
      valid: true
      isPrivate: ev.target.checked

    if ev.target.checked
      key = (Math.random() + 1).toString(36).substring(2, 9)
    else
      key = util.slugify @state.displayName

    @setState key: key

  submit: (ev) ->
    ev.preventDefault()
    return unless @state.valid

    @setState state: ''
    cancelled = not (@state.displayName and @state.key)
    @props.callback cancelled,
      displayName: @state.displayName
      key:         @state.key
      isPrivate:   @state.isPrivate

  render: ->
    unless @state.valid
      invalidWarning = """
        This field must be made up of alphanumeric characters, hyphens, or
        underscores, and it can't start nor end with punctuation.
        """

    isPrivateStr = if @state.isPrivate then '' else 'not'

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
          <Checkbox className="add-queue-is-private"
              name="isPrivate"
              value={@state.isPrivate}
              onClick={@changeIsPrivate}
              title="Privacy"
              helpText="This queue will #{isPrivateStr} be private" />
          <Button>Create</Button>
        </Form>
      </div>
    </div>

module.exports = Modal
