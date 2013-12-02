$(function() {
  $('h3').click(function() {
    $(this).parent().find('.more').slideToggle('fast');
  });
});
