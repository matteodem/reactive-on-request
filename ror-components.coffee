Template.ifRorNewDocuments.hasNew = () ->
  if @collection.rorGetDifference() > 0
    { 'howMany' : @collection.rorGetDifference() }
Template.ifRorRemovedDocuments.hasLess = () ->
  if @collection.rorGetDifference() < 0
    { 'howMany' : -@collection.rorGetDifference() }

Template.ifRorHasChanged.hasChanged = () -> @collection.rorHasChanged()

Template.rorTriggerButton.events(
  'click button' : (e) ->
    @collection.rorTrigger()
    e.preventDefault()
    return
)
