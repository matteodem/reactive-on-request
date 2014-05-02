Package.describe({
  summary: "Only reactively update when the visitor wants to"
});

Package.on_use(function (api, where) {
  api.use(
    ['coffeescript', 'minimongo', 'mongo-livedata', 'underscore', 'deps'],
    ['client', 'server']
  );
  api.add_files('reactive-on-request.coffee', ['client', 'server']);
});
