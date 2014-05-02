(() ->
  Meteor.Collection.prototype.rorTriggerDeps = new Deps.Dependency()
  Meteor.Collection.prototype.rorReactiveDeps = new Deps.Dependency()
  Meteor.Collection.prototype.rorDifference = 0
  Meteor.Collection.prototype.rorChanged = false
  Meteor.Collection.prototype.rorCache =
    findOne : null
    find : null

  # Trigger the reactivity if the user wants to
  Meteor.Collection.prototype.rorTrigger = () ->
    @rorHasBeenTriggered = true
    @rorTriggerDeps.changed()

  # The 'non-reactive' find method
  Meteor.Collection.prototype.rorFind = () ->
    find = @find.apply(this, arguments)
    docs = find.fetch()

    # Make it not reactive
    find.reactive = false

    @rorTriggerDeps.depend()

    # Use local cache to only show the first set of data
    if not @rorCache['find'] and docs? and docs.length > 0
      @rorCache['find'] = docs

    # If trigger has been activated
    if @rorHasBeenTriggered
      @rorChanged = false
      @rorCache['find'] = docs
      @rorHasBeenTriggered = false

    # difference of what is shown and what has reactively been there
    if docs? and @rorCache['find']?
      @rorReactiveDeps.changed()
      @rorChanged = true
      @rorDifference = docs.length - @rorCache['find'].length

    # Fake the cursor to return our cache
    if @rorCache['find']
      find._getRawObjects = () => @rorCache['find']
      find.db_objects = @rorCache['find']

    return find

  # The 'non-reactive' findOne method
  Meteor.Collection.prototype.rorFindOne = () ->
    doc = @findOne.apply(this, arguments)

    @rorTriggerDeps.depend()

    # The document has changed
    if _.isObject(@rorCache['findOne']) and not _.isEqual(@rorCache['findOne'], doc)
      @rorReactiveDeps.changed()
      @rorChanged = true

    @rorCache['findOne'] = doc if not @rorCache['findOne'] and _.size(doc) > 0

    # If trigger has been activated
    if @rorHasBeenTriggered
      @rorChanged = false
      @rorCache['findOne'] = doc
      @rorHasBeenTriggered = false

    return @rorCache['findOne'] ? doc

  # Get the difference of the current documents and the cache
  Meteor.Collection.prototype.rorGetDifference = () ->
    @rorReactiveDeps.depend()
    return @rorDifference

  # Check if something has changed in the docs / the doc
  Meteor.Collection.prototype.rorHasChanged = () ->
    @rorReactiveDeps.depend()
    return @rorChanged
)()
