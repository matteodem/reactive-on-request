#Reactive on Request

Imagine yourself reading through a comment. While you're still busy with reading,
the comment suddenly disappears. The comment has been voted up which causes the
reactivity to push it to the top, since the sorting order is defined like that.

Most of the time reactivity comes in handy but at times like this it would
most certainly confuse people and not be of any advantage. That's what this
package is for.

![Reactive on Request Example](http://i.gyazo.com/d7b86dfc3f923c5309fd0d940d8516c9.png)

## Quick Intro

Simply replace your ```find``` and ```findOne``` uses where reactive-on-request
should be used with following:

```javascript
Collection.rorFind();
Collection.rorFindOne();
```

This will show you the first set of data that is retrieved by the server. Any further
changes can be shown with the provided Blaze Components. Xou can trigger the
reactivity or show that there were changes made to the document(s):

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

The cursor in the above example would be the one that ```rorFind``` returns. If
you would want to use the example for a single document define ```doc=yourDoc```
instead of the cursor parameter. Also yourDoc would have to be the return value of
```rorFindOne```.
