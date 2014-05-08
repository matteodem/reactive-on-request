(() ->
  # The Cache
  c = {}

  # Trigger the reactivity if the user wants to
  rorTrigger = (el) ->
    el._ror.hasBeenTriggered = true
    el._ror.triggerDeps.changed()

  # Get the difference of the current documents and the cache
  rorGetDifference = (el) ->
    el._ror.reactiveDeps.depend()
    return el._ror.difference

  # Check if something has changed in the docs / the doc
  rorHasChanged = (el) ->
    el._ror.reactiveDeps.depend()
    return el._ror.changed

  # Generate an id for cursors
  generateCursorId = (cursor) ->
    return cursor.collection.name

  # Initializes the cache
  initializeCache = (docs) ->
    cache =
      _ror :
        changed      : false
        originalDoc  : docs
        triggerDeps  : new Deps.Dependency()
        reactiveDeps : new Deps.Dependency()
    return cache

  # The 'non-reactive' find method
  Meteor.Collection.prototype.rorFind = () ->
    find = @find.apply(this, arguments)
    docs = find.fetch()

    # Make it not reactive
    find.reactive = false

    # TODO: need a better way to distinct each cursor
    find._id = generateCursorId(find)

    return find if docs.length == 0 and not c[find._id]

    # Use local cache to only show the first set of data
    if not c[find._id]?
      c[find._id] = initializeCache(docs)

    c[find._id]._ror.triggerDeps.depend()

    # If trigger has been activated
    if c[find._id]._ror.hasBeenTriggered
      c[find._id]._ror.changed = false
      c[find._id]._ror.originalDoc = docs
      c[find._id]._ror.hasBeenTriggered = false

    # difference of what is shown and what has reactively been there
    if docs? and c[find._id]._ror.originalDoc?
      c[find._id]._ror.difference = docs.length - c[find._id]._ror.originalDoc.length

    # Fake the cursor to return our cache
    if c[find._id]._ror.originalDoc
      find._getRawObjects = () => c[find._id]._ror.originalDoc
      find.db_objects = c[find._id]._ror.originalDoc

    return find

  # The 'non-reactive' findOne method
  Meteor.Collection.prototype.rorFindOne = () ->
    doc = @findOne.apply(this, arguments)

    return doc if not _.isObject(doc)

    if not c[doc._id]?
      c[doc._id] = initializeCache(doc)

    c[doc._id]._ror.triggerDeps.depend()

    # The document has changed
    if not _.isEqual(c[doc._id]._ror.originalDoc, doc)
      c[doc._id]._ror.changed = true

    # If trigger has been activated
    if c[doc._id]._ror.hasBeenTriggered
      c[doc._id]._ror.changed = false
      c[doc._id]._ror.hasBeenTriggered = false
      c[doc._id]._ror.originalDoc = doc

    return c[doc._id]._ror.originalDoc

  return undefined if Meteor.isServer

  # Only Client

  # ifRorHasChanged
  Template.ifRorHasChanged.difference = () ->
    return { 'difference' : 0 } if @doc and rorHasChanged(c[@doc._id])

    if @cursor
      id = generateCursorId(@cursor)
      difference = rorGetDifference(c[id]) if c[id]?
      c[id]._ror.changed = true if difference? and difference != 0
      return { 'difference' : difference } if c[id]?._ror?.changed

    return null

  # rorTriggerButton
  Template.rorTriggerButton.events(
    'click button' : (e) ->
      rorTrigger(c[@doc._id]) if @doc

      if @cursor?
        id = generateCursorId(@cursor)
        rorTrigger(c[id]) if id?

      e.preventDefault()
      return
  )
)()
