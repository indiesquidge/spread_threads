$(function () {
  return $('a.load-more-items').on('inview', function(e, visible) {
    if (!visible) {
      return;
    }
    return $.getScript($(this).attr('href'));
  });
});
