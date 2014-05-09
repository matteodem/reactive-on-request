#Reactive on Request

Imagine yourself reading through a comment. While you're still busy with reading,
the comment suddenly disappears. The comment has been voted up which causes the
reactivity to push it to the top, since the sorting order is defined like that.

Most of the time reactivity comes in handy but at times like this it would
most certainly confuse people and not be of any advantage. That's what this
package is for.

![Reactive on Request Example](http://i.gyazo.com/d7b86dfc3f923c5309fd0d940d8516c9.png)

## Quick Intro

Simply replace your ``find`` and ``findOne`` uses where reactive-on-request
should be used with following:

```javascript
Collection.rorFind();
Collection.rorFindOne();
```

Add Blaze Components to trigger the reactivity or show changes made to the doc(s).


```html
{{#ifRorHasChanged cursor=comment}}
  <div class="animated fadeInDown">
    <div class="ui info message">
      {{commentPhrase}}
      {{> rorTriggerButton
        cursor=comment
        content="Show"
        class="tiny ui blue button update-comments"
      }}
    </div>
  </div>
{{/ifRorHasChanged}}
```

The cursor in the above example would be the one that ```rorFind``` returns.

## Example

There's an example running on the meteor servers to show how reactive-on-request
could improve user experience: http://ror.meteor.com/

## Using Blaze Components

There are two blaze components which can be used to create the most common blocks.
The example in the Quick Intro shows all of them.

### ifRorHasChanged

If the current document or documents have changed and you want to show it. You can
use the ``difference`` in the ``this`` context to show more granular messages.
* doc (required if no cursor parameter, the doc which rorFind returns)
* cursor (required if no doc parameter, the cursor which rorFind returns)

### rorTriggerButton

Trigger the reactivity and show the newest set of data. Renders a ``<button>`` element.
* doc (required if no cursor parameter, the doc which rorFind returns)
* cursor (required if no doc parameter, the cursor which rorFind returns)
* class (not required, the classes which the button have)
* id (not required, the id of the button element)


## Using the API

Whenever you think the Blaze Components don't provide enough information
you can use the global ```ReactiveOnRequest``` Object to create custom behaviour.

For example:

```javascript
Template.example.events({
  'hover #someButton' : () {
    // Can either be the cursor or doc
    ReactiveOnRequest.trigger(this.comment);
  }
});

// There is also
ReactiveOnRequest.hasChanged(cursorOrDoc);
ReactiveOnRequest.getDifference(cursorOrDoc);
```
