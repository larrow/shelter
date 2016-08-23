$(document).on('turbolinks:load', function() {
  $('input').iCheck({
    checkboxClass: 'icheckbox_square-blue',
    radioClass: 'iradio_square-blue',
    increaseArea: '20%'
  });

  $('.callout').delay(5000).slideUp(800);
});
