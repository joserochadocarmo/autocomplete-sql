fs = require 'fs'
path = require 'path'

module.exports =
class AutocompleteSqlView
  constructor: (serializedState) ->
    # Create root element
    @element = document.createElement('div')
    @element.classList.add('autocomplete-sql')

    # Create message element
    message = document.createElement('div')
    message.textContent = "Please select your connection:"
    message.classList.add('message')
    @element.appendChild(message)

  # Returns an object that can be retrieved when package is activated
  selector: '.source.css, .source.sass'
  
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @element.remove()

  getElement: ->
    @element

  loadProperties: ->
    @properties = {}
    fs.readFile path.resolve(__dirname, '..', 'completionsSqlAnsii.json'), (error, content) =>
      {@pseudoSelectors, @properties, @tags} = JSON.parse(content) unless error?
      console.log({@pseudoSelectors, @properties, @tags});
      return

  getSuggestions: (request) ->
    completions = null
    scopes = request.scopeDescriptor.getScopesArray()
    isSass = hasScope(scopes, 'source.sass')

    if @isCompletingValue(request)
      completions = @getPropertyValueCompletions(request)
    else if @isCompletingPseudoSelector(request)
      completions = @getPseudoSelectorCompletions(request)
    else
      if isSass and @isCompletingNameOrTag(request)
        completions = @getPropertyNameCompletions(request)
          .concat(@getTagCompletions(request))
      else if not isSass and @isCompletingName(request)
        completions = @getPropertyNameCompletions(request)

    if not isSass and @isCompletingTagSelector(request)
      tagCompletions = @getTagCompletions(request)
      if tagCompletions?.length
        completions ?= []
        completions = completions.concat(tagCompletions)

    completions
