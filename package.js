Package.describe({
  summary: "Only reactively update content when the visitor wants to"
});

Package.on_use(function (api, where) {
  api.use(
    ['coffeescript', 'minimongo', 'mongo-livedata',
      'underscore', 'deps', 'templating', 'ui'],
    ['client', 'server']
  );

  api.add_files('ror-components.html', 'client');
  api.add_files('reactive-on-request.coffee', ['client', 'server']);

  api.export('ReactiveOnRequest');
});
