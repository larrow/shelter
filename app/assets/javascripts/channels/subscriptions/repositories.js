$(document).on('turbolinks:load', function() {
  $('[data-auto-update-repositories]').each(function() {
    var el = this;
    App.cable.subscriptions.create({channel: 'NamespaceChannel', namespace: $(el).data('auto-update-repositories')}, {
      received: function(data) {
        if(data['action'] === 'new_repository') {
          $(el).prepend(data['content']);
          $('.no_repository').remove();
        }
      },
    });
  })
});
