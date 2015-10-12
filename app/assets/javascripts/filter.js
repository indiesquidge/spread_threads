$(document).ready(function () {
  listFilter($('#header'), $('#items'));
});

function listFilter(header, list) {
  jQuery.expr[':'].Contains = function (a, i, m) {
    return (a.textContent || a.innerText || '')
      .toUpperCase().indexOf(m[3].toUpperCase()) >= 0;
  };

  var form = $('<form>').attr({'class':'filterform', 'action':'#'});
  var input = $('<input>').attr({'class':'filterinput', 'type':'text', 'placeholder':'Filter'});
  $(form).append(input).appendTo(header);

  $(input).change(function () {
    var filter = $(this).val();
    $(list).find('.title:not(:Contains(' + filter + '))').parents('.item').slideUp();
    $(list).find('.title:Contains(' + filter + ')').parents('.item').slideDown();
  }).keyup(function () {
    $(this).change();
  });
}
