$(document).on('turbolinks:load', function() {
  $('.submit-on-change').on('ifChanged', function() {
    $(this).parents('form').submit();
  });
});
