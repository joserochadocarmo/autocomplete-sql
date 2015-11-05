AutocompleteSqlView = require './autocomplete-sql-view'
{CompositeDisposable} = require 'atom'

module.exports = AutocompleteSql =
  autocompleteSqlView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @autocompleteSqlView = new AutocompleteSqlView(state.autocompleteSqlViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @autocompleteSqlView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'autocomplete-sql:toggle': => @toggle()

    @autocompleteSqlView.loadProperties();

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @autocompleteSqlView.destroy()

  serialize: ->
    autocompleteSqlViewState: @autocompleteSqlView.serialize()

  toggle: ->
    console.log 'AutocompleteSql was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()

  getProvider: -> @autocompleteSqlView
