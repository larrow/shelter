$(document).on('turbolinks:load', function() {
  $('[data-auto-update-tags]').each(function() {
    var el = this;
    App.cable.subscriptions.create({channel: 'RepositoryChannel', id: $(el).data('auto-update-tags')}, {
      received: function(data) {
        if(data['action'] === 'push') {
          Turbolinks.visit(location.href);
        }
      },
    });
  })
});
